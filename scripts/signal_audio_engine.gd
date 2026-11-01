extends RefCounted
class_name DeadAirSignalAudioEngine

const SAMPLE_RATE := 22050
const SpeechEngine = preload("res://scripts/speech_engine.gd")
const MORSE := {
	"A":".-", "B":"-...", "C":"-.-.", "D":"-..", "E":".", "F":"..-.",
	"G":"--.", "H":"....", "I":"..", "J":".---", "K":"-.-", "L":".-..",
	"M":"--", "N":"-.", "O":"---", "P":".--.", "Q":"--.-", "R":".-.",
	"S":"...", "T":"-", "U":"..-", "V":"...-", "W":".--", "X":"-..-",
	"Y":"-.--", "Z":"--..",
	"0":"-----", "1":".----", "2":"..---", "3":"...--", "4":"....-",
	"5":".....", "6":"-....", "7":"--...", "8":"---..", "9":"----."
}

static func build_event_audio(event: Dictionary, speech_rate: float = 1.0) -> AudioStreamWAV:
	var mode := String(event.get("mode", "")).to_upper()
	var kind := String(event.get("kind", "")).to_upper()
	var classification := String(event.get("classification", "")).to_upper()
	if mode == "CW":
		var identifier := String(event.get("identifier", "")).replace("-", "")
		var sequence := String(event.get("sequence", ""))
		return _build_morse(identifier + " " + sequence, 18.0)
	if kind == "TIME STANDARD" or classification == "REFERENCE":
		return _render_segments([{"tone":1000.0, "secondary":73.0, "duration":1.15, "amplitude":0.20}])
	if classification.contains("DATA") or kind.contains("DATA"):
		return _build_data_burst()
	if classification.contains("VOICE") or kind == "ROUTINE TRAFFIC":
		return SpeechEngine.synthesize(String(event.get("transcript", "")), speech_rate, 0.94)
	return SpeechEngine.synthesize(String(event.get("transcript", "")), speech_rate, 0.94)

static func _build_morse(message: String, words_per_minute: float) -> AudioStreamWAV:
	var unit := 1.2 / clampf(words_per_minute, 8.0, 30.0)
	var segments: Array = []
	var words := message.to_upper().split(" ", false)
	for word_index in range(words.size()):
		var word: String = words[word_index]
		for char_index in range(word.length()):
			var character := word.substr(char_index, 1)
			var code := String(MORSE.get(character, ""))
			if code.is_empty():
				continue
			for element_index in range(code.length()):
				var element := code.substr(element_index, 1)
				segments.append({"tone":700.0, "duration":unit * (3.0 if element == "-" else 1.0), "amplitude":0.24})
				if element_index < code.length() - 1:
					segments.append({"tone":0.0, "duration":unit})
			if char_index < word.length() - 1:
				segments.append({"tone":0.0, "duration":unit * 3.0})
		if word_index < words.size() - 1:
			segments.append({"tone":0.0, "duration":unit * 7.0})
	return _render_segments(segments)

static func _build_data_burst() -> AudioStreamWAV:
	# A short, deliberately unrecoverable FSK-like training burst. It carries no hidden payload.
	var bits := "101100101001011010010110"
	var segments: Array = [{"tone":1200.0, "duration":0.06, "amplitude":0.16}]
	for i in range(bits.length()):
		segments.append({"tone":2200.0 if bits.substr(i, 1) == "1" else 1200.0, "duration":0.018, "amplitude":0.18})
	segments.append({"tone":0.0, "duration":0.08})
	return _render_segments(segments)

static func _render_segments(segments: Array) -> AudioStreamWAV:
	if segments.is_empty():
		return null
	var total_frames := 0
	for segment in segments:
		total_frames += int(float(segment.get("duration", 0.0)) * float(SAMPLE_RATE))
	total_frames = clampi(total_frames, 1, SAMPLE_RATE * 15)
	var pcm := PackedByteArray()
	pcm.resize(total_frames * 2)
	var frame := 0
	var phase := 0.0
	for segment in segments:
		var duration := float(segment.get("duration", 0.0))
		var count := maxi(1, int(duration * float(SAMPLE_RATE)))
		var tone := float(segment.get("tone", 0.0))
		var secondary := float(segment.get("secondary", 0.0))
		var amplitude := float(segment.get("amplitude", 0.0))
		for i in range(count):
			if frame >= total_frames:
				break
			var t := float(i) / float(count)
			var edge := minf(1.0, minf(t * duration * 250.0, (1.0 - t) * duration * 250.0))
			var sample := 0.0
			if tone > 0.0:
				phase += TAU * tone / float(SAMPLE_RATE)
				sample = sin(phase) * amplitude
				if secondary > 0.0:
					sample += sin(TAU * secondary * float(frame) / float(SAMPLE_RATE)) * 0.025
			pcm.encode_s16(frame * 2, int(round(clampf(sample * edge, -0.9, 0.9) * 32767.0)))
			frame += 1
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = SAMPLE_RATE
	stream.stereo = false
	stream.data = pcm
	return stream

extends RefCounted
class_name DeadAirSpeechEngine

# Fully local formant speech synthesizer. No model download, network, microphone,
# Android speech service, or external voice asset is required.
const SAMPLE_RATE := 22050
const BASE_PITCH := 112.0
const LETTER_NAMES := {
	"A":"ay", "B":"bee", "C":"see", "D":"dee", "E":"ee", "F":"eff",
	"G":"gee", "H":"aitch", "I":"eye", "J":"jay", "K":"kay", "L":"ell",
	"M":"em", "N":"en", "O":"oh", "P":"pee", "Q":"cue", "R":"ar",
	"S":"ess", "T":"tee", "U":"you", "V":"vee", "W":"double you",
	"X":"ex", "Y":"why", "Z":"zee"
}
const DIGITS := ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
const VOWELS := {
	"a":[760.0, 1250.0, 2600.0], "e":[530.0, 1840.0, 2480.0],
	"i":[300.0, 2200.0, 3000.0], "o":[500.0, 950.0, 2500.0],
	"u":[350.0, 850.0, 2200.0], "ee":[300.0, 2200.0, 3000.0],
	"oo":[350.0, 800.0, 2200.0], "ay":[520.0, 1750.0, 2550.0],
	"eye":[330.0, 2050.0, 2900.0], "oh":[500.0, 950.0, 2500.0],
	"ow":[450.0, 1150.0, 2450.0], "er":[480.0, 1350.0, 1650.0]
}

static func synthesize(source_text: String, speed: float = 1.0, pitch: float = 1.0) -> AudioStreamWAV:
	var spoken := _expand_text(source_text)
	var segments := _phonemize(spoken)
	if segments.is_empty():
		return null
	var samples := PackedFloat32Array()
	var rate := clampf(speed, 0.65, 1.4)
	var pitch_scale := clampf(pitch, 0.75, 1.35)
	var phase := 0.0
	for segment in segments:
		var kind := String(segment.get("kind", "voice"))
		if kind == "pause":
			var pause_count := int(float(segment.get("duration", 0.08)) * float(SAMPLE_RATE) / rate)
			for _p in range(pause_count):
				samples.append(0.0)
			continue
		var duration := float(segment.get("duration", 0.075)) / rate
		var count := maxi(1, int(duration * float(SAMPLE_RATE)))
		var f1 := float(segment.get("f1", 500.0))
		var f2 := float(segment.get("f2", 1500.0))
		var f3 := float(segment.get("f3", 2500.0))
		var voiced := kind != "noise"
		var fricative := kind == "noise"
		for i in range(count):
			var t := float(i) / float(count)
			var edge := minf(1.0, t * 12.0) * minf(1.0, (1.0 - t) * 10.0)
			var sample := 0.0
			if voiced:
				phase += TAU * BASE_PITCH * pitch_scale / float(SAMPLE_RATE)
				var fundamental := sin(phase) * 0.18
				var formant_a := sin(TAU * f1 * float(i) / float(SAMPLE_RATE) + phase * 0.13) * 0.34
				var formant_b := sin(TAU * f2 * float(i) / float(SAMPLE_RATE) + phase * 0.21) * 0.23
				var formant_c := sin(TAU * f3 * float(i) / float(SAMPLE_RATE) + phase * 0.31) * 0.12
				sample = fundamental + formant_a + formant_b + formant_c
			if fricative:
				var noise_seed := sin(float(i + samples.size()) * 12.9898 + f2) * 43758.5453
				var noise_value := (noise_seed - floor(noise_seed)) * 2.0 - 1.0
				sample = noise_value * 0.20
			samples.append(clampf(sample * edge * 0.72, -0.85, 0.85))
		phase += 0.04
	var pcm := PackedByteArray()
	pcm.resize(samples.size() * 2)
	for i in range(samples.size()):
		pcm.encode_s16(i * 2, int(round(samples[i] * 32767.0)))
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = SAMPLE_RATE
	stream.stereo = false
	stream.data = pcm
	return stream

static func _expand_text(source: String) -> String:
	var result := ""
	var i := 0
	while i < source.length():
		var character := source.substr(i, 1)
		if character >= "A" and character <= "Z":
			var run := ""
			while i < source.length():
				var next_character := source.substr(i, 1)
				if next_character < "A" or next_character > "Z":
					break
				run += next_character
				i += 1
			if run.length() >= 2:
				for letter_index in range(run.length()):
					var letter := run.substr(letter_index, 1)
					result += " " + String(LETTER_NAMES.get(letter, letter.to_lower())) + " "
			else:
				result += run.to_lower()
			continue
		elif character >= "0" and character <= "9":
			result += " " + String(DIGITS[int(character)]) + " "
		elif character == "-" or character == "_" or character == "/":
			result += " "
		else:
			result += character.to_lower()
		i += 1
	return result

static func _phonemize(text: String) -> Array:
	var result: Array = []
	var i := 0
	while i < text.length():
		var one := text.substr(i, 1)
		var two := text.substr(i, 2) if i + 1 < text.length() else ""
		if one == " " or one == "\t":
			result.append({"kind":"pause", "duration":0.045})
			i += 1
			continue
		if one == "." or one == "," or one == ";" or one == ":" or one == "?" or one == "!":
			result.append({"kind":"pause", "duration":0.12 if one == "." or one == "!" or one == "?" else 0.065})
			i += 1
			continue
		var vowel_key := ""
		if ["ee", "oo", "ay", "ai", "ey", "ow", "ou", "er"].has(two):
			vowel_key = {"ai":"ay", "ey":"ay", "ou":"ow"}.get(two, two)
		elif VOWELS.has(one):
			vowel_key = one
		if not vowel_key.is_empty():
			var formants: Array = VOWELS[vowel_key]
			result.append({"kind":"voice", "f1":formants[0], "f2":formants[1], "f3":formants[2], "duration":0.105})
			i += 2 if two in ["ee", "oo", "ay", "ai", "ey", "ow", "ou", "er"] else 1
			continue
		if ["sh", "ch", "th", "ng"].has(two):
			if two == "ng":
				result.append({"kind":"voice", "f1":330.0, "f2":1250.0, "f3":2200.0, "duration":0.075})
			else:
				result.append({"kind":"noise", "f2":2200.0, "duration":0.065})
			i += 2
			continue
		if "sfh".contains(one):
			result.append({"kind":"noise", "f2":2400.0, "duration":0.055})
		elif "mnrlwy".contains(one):
			result.append({"kind":"voice", "f1":330.0, "f2":1150.0 if one != "y" else 1900.0, "f3":2300.0, "duration":0.065})
		elif "bdg".contains(one):
			result.append({"kind":"voice", "f1":420.0, "f2":1350.0, "f3":2300.0, "duration":0.055})
		elif "ptk".contains(one):
			result.append({"kind":"noise", "f2":1800.0, "duration":0.035})
		elif "vcjz".contains(one):
			result.append({"kind":"voice", "f1":450.0, "f2":1750.0, "f3":2600.0, "duration":0.05})
		else:
			result.append({"kind":"pause", "duration":0.025})
		i += 1
	return result

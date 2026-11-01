extends RefCounted
class_name DeadAirSpeechEngine

# Fully local formant speech synthesizer. No model download, network, microphone,
# Android speech service, or external voice asset is required.
const SAMPLE_RATE := 22050
const WAVE_TABLE_SIZE := 2048
const BASE_PITCH := 112.0
const VOICE_PROFILES := {
	"FIELD":{"pitch":0.96, "formant":1.0, "amplitude":0.94, "rate":1.0},
	"AMATEUR":{"pitch":1.08, "formant":1.04, "amplitude":1.0, "rate":1.03},
	"OFFICIAL":{"pitch":0.84, "formant":0.94, "amplitude":0.90, "rate":0.96}
}
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

static func synthesize(source_text: String, speed: float = 1.0, pitch: float = 1.0, voice_profile: String = "FIELD") -> AudioStreamWAV:
	var spoken := _expand_text(source_text)
	var segments := _phonemize(spoken)
	if segments.is_empty():
		return null
	var profile: Dictionary = VOICE_PROFILES.get(voice_profile.to_upper(), VOICE_PROFILES["FIELD"])
	var rate := clampf(speed * float(profile.get("rate", 1.0)), 0.65, 1.4)
	var pitch_scale := clampf(pitch * float(profile.get("pitch", 1.0)), 0.65, 1.5)
	var formant_scale := float(profile.get("formant", 1.0))
	var amplitude_scale := float(profile.get("amplitude", 1.0))
	var sine_table := PackedFloat32Array()
	sine_table.resize(WAVE_TABLE_SIZE)
	for table_index in range(WAVE_TABLE_SIZE):
		sine_table[table_index] = sin(TAU * float(table_index) / float(WAVE_TABLE_SIZE))
	var total_frames := 0
	for segment in segments:
		var duration := float(segment.get("duration", 0.08))
		total_frames += int(duration * float(SAMPLE_RATE) / rate)
	total_frames = clampi(total_frames, 1, SAMPLE_RATE * 60)
	var pcm := PackedByteArray()
	pcm.resize(total_frames * 2)
	var write_index := 0
	var pitch_phase := 0.0
	var phase_a := 0.0
	var phase_b := 0.0
	var phase_c := 0.0
	var noise_state := 0x234567
	for segment in segments:
		if write_index >= total_frames:
			break
		var kind := String(segment.get("kind", "voice"))
		if kind == "pause":
			var pause_count := int(float(segment.get("duration", 0.08)) * float(SAMPLE_RATE) / rate)
			for _p in range(pause_count):
				if write_index >= total_frames:
					break
				pcm.encode_s16(write_index * 2, 0)
				write_index += 1
			continue
		var duration := float(segment.get("duration", 0.075)) / rate
		var count := maxi(1, int(duration * float(SAMPLE_RATE)))
		var f1 := float(segment.get("f1", 500.0)) * formant_scale
		var f2 := float(segment.get("f2", 1500.0)) * formant_scale
		var f3 := float(segment.get("f3", 2500.0)) * formant_scale
		var voiced := kind != "noise"
		var pitch_increment := BASE_PITCH * pitch_scale * float(WAVE_TABLE_SIZE) / float(SAMPLE_RATE)
		var increment_a := f1 * float(WAVE_TABLE_SIZE) / float(SAMPLE_RATE)
		var increment_b := f2 * float(WAVE_TABLE_SIZE) / float(SAMPLE_RATE)
		var increment_c := f3 * float(WAVE_TABLE_SIZE) / float(SAMPLE_RATE)
		for i in range(count):
			if write_index >= total_frames:
				break
			var t := float(i) / float(count)
			var edge := minf(1.0, minf(t * 12.0, (1.0 - t) * 10.0))
			noise_state = int((noise_state * 1103515245 + 12345) & 0x7fffffff)
			var noise_value := float(noise_state & 0xffff) / 32767.5 - 1.0
			var sample := 0.0
			if voiced:
				sample = sine_table[int(pitch_phase)] * 0.18
				sample += sine_table[int(phase_a)] * 0.34
				sample += sine_table[int(phase_b)] * 0.23
				sample += sine_table[int(phase_c)] * 0.12
				sample += noise_value * 0.008
				pitch_phase += pitch_increment
				phase_a += increment_a
				phase_b += increment_b
				phase_c += increment_c
				if pitch_phase >= WAVE_TABLE_SIZE: pitch_phase -= WAVE_TABLE_SIZE
				if phase_a >= WAVE_TABLE_SIZE: phase_a -= WAVE_TABLE_SIZE
				if phase_b >= WAVE_TABLE_SIZE: phase_b -= WAVE_TABLE_SIZE
				if phase_c >= WAVE_TABLE_SIZE: phase_c -= WAVE_TABLE_SIZE
			else:
				sample = noise_value * 0.20
			pcm.encode_s16(write_index * 2, int(round(clampf(sample * edge * 0.72 * amplitude_scale, -0.85, 0.85) * 32767.0)))
			write_index += 1
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
	return " ".join(result.split(" ", false))

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

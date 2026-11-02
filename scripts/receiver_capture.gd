extends RefCounted
class_name DeadAirReceiverCapture

# In-memory PCM of the locally generated receiver monitor, not RF, microphone,
# authored institutional audio, or proof of an actual transmission.
const SAMPLE_RATE := 22050
const BUFFER_SECONDS := 90
const PRE_ROLL_SECONDS := 30

var _channel_frequency := -1.0
var _channel_mode := ""
var _chunks: Array[PackedByteArray] = []
var _buffer_bytes := 0
var _active_bytes := PackedByteArray()
var _recording := false
var _pre_roll_samples := 0

func retune(frequency_mhz: float, mode: String) -> void:
	if is_equal_approx(_channel_frequency, frequency_mhz) and _channel_mode == mode:
		return
	_channel_frequency = frequency_mhz
	_channel_mode = mode
	_chunks.clear()
	_buffer_bytes = 0

func ingest(frames: PackedVector2Array, frequency_mhz: float, mode: String) -> void:
	retune(frequency_mhz, mode)
	if frames.is_empty():
		return
	var pcm := PackedByteArray()
	pcm.resize(frames.size() * 2)
	for i in range(frames.size()):
		var sample := clampi(int(round((frames[i].x + frames[i].y) * 16383.5)), -32768, 32767)
		pcm[i * 2] = sample & 255
		pcm[i * 2 + 1] = (sample >> 8) & 255
	_chunks.append(pcm)
	_buffer_bytes += pcm.size()
	if _recording:
		_active_bytes.append_array(pcm)
	var max_bytes := SAMPLE_RATE * BUFFER_SECONDS * 2
	while _buffer_bytes > max_bytes and not _chunks.is_empty():
		var oldest: PackedByteArray = _chunks.pop_front()
		_buffer_bytes -= oldest.size()

func start(include_pre_roll: bool = true) -> bool:
	if _recording:
		return false
	_active_bytes = PackedByteArray()
	_pre_roll_samples = 0
	if include_pre_roll:
		var target_bytes := SAMPLE_RATE * PRE_ROLL_SECONDS * 2
		var collected := PackedByteArray()
		for i in range(_chunks.size() - 1, -1, -1):
			var chunk: PackedByteArray = _chunks[i]
			var remaining := target_bytes - collected.size()
			if remaining <= 0:
				break
			var chosen: PackedByteArray = chunk.slice(maxi(0, chunk.size() - remaining))
			var joined := PackedByteArray()
			joined.append_array(chosen)
			joined.append_array(collected)
			collected = joined
		_active_bytes = collected
		_pre_roll_samples = int(collected.size() / 2)
	_recording = true
	return true

func is_recording() -> bool:
	return _recording

func stop() -> Dictionary:
	if not _recording:
		return {}
	_recording = false
	var result := {
		"pcm": _active_bytes.duplicate(),
		"samples": int(_active_bytes.size() / 2),
		"pre_roll_samples": _pre_roll_samples,
		"sample_rate": SAMPLE_RATE,
		"frequency_mhz": _channel_frequency,
		"mode": _channel_mode
	}
	_active_bytes = PackedByteArray()
	_pre_roll_samples = 0
	return result

func buffered_seconds() -> float:
	return float(_buffer_bytes) / float(SAMPLE_RATE * 2)

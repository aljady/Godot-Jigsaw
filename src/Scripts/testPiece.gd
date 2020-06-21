extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("ready")
	do_things()

func do_things() -> void:
	var target_size :float = 3.0
	var interval = 1 / (target_size)
	print("--- interval: " + str(interval))

	for bloop in range(0, 11, 1):
		var val = bloop / 10.0
		var mod = val - fmod(val, interval)
		print("Val: " + str(val) + ", Mod: " + str(mod))
		var bleps = (val - fmod(val, interval)) / interval


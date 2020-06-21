extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("ready")
	do_things()

func do_things() -> void:
	var target_size :float = 4
	var interval = 1 / (target_size)
	print("--- interval: " + str(interval))

	for bloop in range(0, 10, 1):
		var blooper = bloop / 10.0
		var bleps = (blooper - fmod(blooper, interval)) / interval
		print("value: " + str(blooper) + ", POS: " + str(bleps + 1))
#		var bloopies = round(blooper * target_size) / target_size
#		print(bloopies)

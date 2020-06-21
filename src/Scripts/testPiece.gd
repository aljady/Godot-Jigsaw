extends Node2D

const saved_mat = preload("res://src/piece_sh_m.tres")

onready var sp :Sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	do_things()

func do_things() -> void:
	var mat :ShaderMaterial = sp.material

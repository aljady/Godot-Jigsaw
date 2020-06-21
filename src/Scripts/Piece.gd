extends Node2D

onready var sprite 		:Sprite 			= $Sprite
onready var sensor 		:Area2D 			= $Sensor
onready var collision	:CollisionShape2D 	= $Sensor/Shape

var id
var dir
var row
var col
var edge_top
var edge_right
var edge_bottom
var edge_left
var final_position

signal piece_mouse_entered
signal piece_mouse_exited

var is_dragged :bool = false


func _ready() -> void:

	connect("piece_mouse_entered", self.get_parent().get_parent(), "_on_piece_mouse_entered")
	connect("piece_mouse_exited", self.get_parent().get_parent(), "_on_piece_mouse_exited")

func _on_Area_mouse_entered() -> void:
	emit_signal("piece_mouse_entered", self)


func _on_Area_mouse_exited() -> void:
	emit_signal("piece_mouse_exited", self)


func _on_Area_area_entered(area: Area2D) -> void:
	if is_dragged == true:
		if self.z_index <= area.get_parent().z_index:
			self.z_index = area.get_parent().z_index + 10


func _on_Area_area_exited(area: Area2D) -> void:
	pass

extends Node2D

onready var sprite 		:Sprite 			= $Sprite
onready var sensor 		:Area2D 			= $Sensor
onready var collision	:CollisionShape2D 	= $Sensor/Shape

onready var controller = self.get_parent().get_parent()

var id
var dir
var row
var col
var edge_top
var edge_right
var edge_bottom
var edge_left
var final_position

var overlapping_pieces = []
var is_selected :bool
var is_on_top: bool

var mouse_drag_offset


func _ready() -> void:
	pass


func _on_Area_mouse_entered() -> void:
	controller.pieces_under_cursor[self.id] = self


func _on_Area_mouse_exited() -> void:
	is_selected = false
	controller.pieces_under_cursor.erase(self.id)


func _on_Area_area_entered(area: Area2D) -> void:
	if is_selected == true:
		if self.z_index <= area.get_parent().z_index:
			self.z_index = area.get_parent().z_index + 10


func _on_Area_area_exited(area: Area2D) -> void:
	pass


func _on_Area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:

	if controller.is_piece_on_top(controller.pieces_under_cursor, self) == true:
		is_on_top = true

		if event is InputEventMouseButton:
			if event.is_action_pressed("action"):
				###################################################
				print(self.sprite.material)
				print(self.sprite.material.get_shader_param("mask"))
				###################################################
				mouse_drag_offset = self.get_local_mouse_position()
				is_selected = true
				for ar in sensor.get_overlapping_areas():
					var overlap_piece = ar.get_parent()
					if self.z_index <= overlap_piece.z_index: self.z_index = overlap_piece.z_index+1

			if event.is_action_released("action"):
				is_selected = false

		if event is InputEventMouseMotion && is_selected == true:
			self.position = get_global_mouse_position() - mouse_drag_offset

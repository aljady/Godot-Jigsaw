extends Node2D

export var pieces_amount :Vector2
export var pieces_resolution :Vector2

const myPiece = preload("res://src/scenes/piece.tscn")
const myImage = "res://src/Textures/forest01.jpg"
const myShader = preload("res://src/shaders/piece_alpha.shader")
const myMask = "res://src/textures/testmask.png"

onready var Pic 	:Sprite 	= $JigsawPic
onready var Cam 	:Camera2D 	= $Camera2D
onready var Pieces	:Node2D 	= $Pieces

var pieces_under_cursor = {}
var action_pressed :bool = false
var piece_pressed :bool = false
var active_piece

var img_texture 	:ImageTexture
var msk_texture		:ImageTexture
var tex 			:AtlasTexture
var mat				:ShaderMaterial


func _ready() -> void:
	# Load Image
	img_texture = ImageTexture.new()
	img_texture.load(myImage)
	msk_texture = ImageTexture.new()
	msk_texture.load(myMask)
	setup_board()
	generate_pieces(pieces_amount)


func _unhandled_input(event: InputEvent) -> void:

	# Button
	if event is InputEventMouseButton:
		## Zoom in
		if event.is_action("zoom_in"):
			if Cam.zoom > Vector2(0.4, 0.4): Cam.zoom -= Vector2(0.1,0.1)
		## Zoom out
		if event.is_action("zoom_out"):
			if Cam.zoom < Vector2(3, 3): Cam.zoom += Vector2(0.1,0.1)
		## Press
		if event.is_action_pressed("action"):
			action_pressed = true
			if pieces_under_cursor.empty():
				piece_pressed = false
			else:
				piece_pressed = true
				active_piece = _get_top_piece()
				_put_on_top(active_piece)
		## Long press
		#//TODO
		## Release
		if event.is_action_released("action"):
			action_pressed = false
			piece_pressed = false
			if not active_piece == null: active_piece.is_dragged = false

	# Motion
	if event is InputEventMouseMotion:
		if action_pressed == true:
			if piece_pressed == true:
				## Move Piece
				active_piece.is_dragged = true
				active_piece.position = get_global_mouse_position()
			else:
				## Pan Camera
				get_tree().set_input_as_handled()
				Cam.position -= event.relative * Cam.zoom


func _on_piece_mouse_entered(p) -> void:
	pieces_under_cursor[p.id] = p


func _on_piece_mouse_exited(p) -> void:
	pieces_under_cursor.erase(p.id)


func _get_top_piece() -> PackedScene:
	var top_z = -99
	var top_p
	for p in pieces_under_cursor.values():
		if p.z_index > top_z:
			top_z = p.z_index
			top_p = p
	return top_p


func _put_on_top(p) -> void:
	for ar in p.sensor.get_overlapping_areas():
		var ov_p = ar.get_parent()
		if p.z_index <= ov_p.z_index: p.z_index = ov_p.z_index + 1


func setup_board() -> void:
	Pic.position = Vector2(0,0)
	#Cam.position = Vector2(0,0)


static func piece_idx(rows, row, col) -> int:
	return (rows * col) + row


func generate_pieces(dimensions :Vector2) -> void:

	var rows = dimensions.x
	var columns = dimensions.y

	var piece_x = Pic.texture.get_width() / float(columns)
	var piece_y = Pic.texture.get_height() / float(rows)

	for row in rows:
		for col in columns:

			var new_piece = myPiece.instance()
			Pieces.add_child(new_piece)

			# Texture
			var tex = AtlasTexture.new()
			tex.set_atlas(img_texture)
			new_piece.sprite.set_texture(tex)
			new_piece.sprite.texture.set_region(Rect2(piece_x * col, piece_y * row, piece_x, piece_y))

			# Material
			var mat = ShaderMaterial.new()
			mat.set_shader(myShader)
			new_piece.sprite.set_material(mat)
			mat.set_shader_param("region_origin", Vector2(piece_x * col, piece_y * row))
			mat.set_shader_param("region_size", Vector2(piece_x, piece_y))
			mat.set_shader_param("target_size", Vector2(float(pieces_resolution.x), float(pieces_resolution.y)))
			mat.set_shader_param("mask", msk_texture)

			# Collision shape
			new_piece.collision.shape.extents = Vector2(piece_x / 2, piece_y / 2)

			# Position
			new_piece.position = Vector2((piece_x * col) + (piece_x / 2), (piece_y * row) + (piece_y / 2))
			new_piece.final_position = Vector2((piece_x * col) + (piece_x / 2), (piece_y * row) + (piece_y / 2))

			# Properties
			new_piece.id = piece_idx(rows, row, col)
			new_piece.dir = 'N'
			new_piece.row = row
			new_piece.col = col
			new_piece.edge_top 		= piece_idx(rows, row-1, col) if row > 0 else null
			new_piece.edge_right 	= piece_idx(rows, row, col+1) if col < columns-1 else null
			new_piece.edge_bottom 	= piece_idx(rows, row+1, col) if row < rows-1 else null
			new_piece.edge_left 	= piece_idx(rows, row, col-1) if col > 0 else null


func _on_HSlider_value_changed(value: float) -> void:
	var pieces_folder :Node2D = $Pieces
	for p in pieces_folder.get_children():
			p.sprite.material.set_shader_param("target_size", Vector2(value, value))

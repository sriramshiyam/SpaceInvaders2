extends Node2D

class_name Combo

@onready var combo_number_label: Label = $HBox/ComboNumberLabel
@onready var h_box: HBoxContainer = $HBox
@onready var animation_player: AnimationPlayer = $AnimationPlayer2

var rotate_spring: Dictionary
var rest_timer: float = 0

func _ready() -> void:
	create_rotate_spring()

func create_rotate_spring() -> void:
	rotate_spring = Util.get_spring(0.8, 0.4, -20)
	
func _process(delta: float) -> void:
	handle_rotate_spring(delta)

func handle_rotate_spring(delta: float) -> void:
	rotation_degrees = Util.calculate_spring(rotation_degrees, rotate_spring)
	
	if rotation_degrees > -20.5 and rotation_degrees < -19.5:
		rest_timer -= delta
	else:
		rest_timer = 0.2
	
	if rest_timer < 0:
		animation_player.play("scale")
		

func set_combo_number(number: int) -> void:
	combo_number_label.text = "%d!" % number

func move_label_to_center() -> void:
	h_box.position.x -= h_box.size.x / 2
	h_box.position.y -= h_box.size.y / 2

func _on_animation_player_2_animation_finished(anim_name: StringName) -> void:
	if anim_name == "scale":
		queue_free()

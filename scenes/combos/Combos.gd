extends Node2D

const COMBO = preload("res://scenes/combo/Combo.tscn")

@onready var combo_sound: AudioStreamPlayer = $ComboSound

var combo_number: int
var combo_timer: float

func _ready() -> void:
	combo_number = 0
	combo_timer = 0

func _enter_tree() -> void:
	SignalBus.create_combo.connect(add_combo)

func _process(delta: float) -> void:
	if combo_timer < 0.5:
		combo_timer += delta
	if combo_timer > 0.5:
		combo_number = 0

func add_combo(pos: Vector2) -> void:
	combo_number += 1

	if combo_timer < 0.5:
		var combo: Combo = COMBO.instantiate()
		add_child(combo)

		combo.global_position = pos
		combo.set_combo_number(combo_number)
		combo.move_label_to_center()

		combo_sound.play()

	combo_timer = 0
	handle_hud()


func handle_hud() -> void:
	Hud.kills += 1
	Hud.score += combo_number
	if Hud.max_combo < combo_number:
		Hud.max_combo = combo_number

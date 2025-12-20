extends Control

class_name Hud

@onready var score_label: Label = $MC/VB/ScoreLabel
@onready var lives_label: Label = $MC/VB/LivesLabel
@onready var max_combo_label: Label = $MC/VB/MaxComboLabel
@onready var waves_label: Label = $MC/VB/WavesLabel
@onready var kills_label: Label = $MC/VB/KillsLabel

static var score: int = 0
static var lives: String = "❤️❤️❤️"
static var max_combo: int = 0
static var waves: int = 0
static var kills: int = 0

static func reset() -> void:
	score = 0
	lives = "❤️❤️❤️"
	max_combo = 0
	waves = 0
	kills = 0

func _process(_delta: float) -> void:
	score_label.text = "%d" % score
	lives_label.text = lives
	max_combo_label.text = "%d" % max_combo
	waves_label.text = "%d" % waves
	kills_label.text = "%d" % kills

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		SignalBus.emit_start_game()

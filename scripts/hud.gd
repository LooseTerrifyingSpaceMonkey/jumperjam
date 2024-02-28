extends Control

signal pause_game

@onready var topbar = $TopBar
@onready var topbar_bg = $TopBarBG
@onready var score_label = $TopBar/ScoreLabel

@export var margin = 10

func _ready():
	var os_name = OS.get_name()
	if os_name == "Android" or os_name == "iOS":
		var safe_area = DisplayServer.get_display_safe_area()
		var safe_area_top = safe_area.position.y 
		
		if os_name == "iOS":
			var screen_scale = DisplayServer.screen_get_scale()
			safe_area_top = safe_area_top / screen_scale
			MyUtility.add_log_message("Screen scale: " + str(screen_scale))
			
		topbar.position.y += safe_area_top
		topbar_bg.size.y += safe_area_top + margin
		
		MyUtility.add_log_message("Safe area: " + str(safe_area))
		MyUtility.add_log_message("Window size: " + str(DisplayServer.window_get_size()))
		MyUtility.add_log_message("Safe area top: " + str(safe_area_top))
		MyUtility.add_log_message("Top bar position: " + str(topbar.position))
	
func _on_pause_button_pressed():
	SoundFX.play("Click")
	pause_game.emit()

func set_score(new_score: int):
	score_label.text = str(new_score)

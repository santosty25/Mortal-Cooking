extends CanvasLayer

@onready var score_label = $ScoreLabel

func _ready():
	score_label.text = "Score: $" + str(Global.end_score)
	
func _on_retry_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")
	hide()


func _on_quit_pressed():
	get_tree().quit()


func _on_retry_nux_pressed():
	get_tree().change_scene_to_file("res://Scenes/Nux.tscn")

extends CanvasLayer

@onready var main = get_tree().root.get_node("Main")

func _on_resume_pressed():
	main.pauseMenu()


func _on_quit_pressed():
	get_tree().quit()

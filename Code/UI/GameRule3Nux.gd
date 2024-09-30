extends Control

@onready var Next = $"Panel/Next" as Button
@onready var Back = $"Panel/Back" as Button

# Called when the node enters the scene tree for the first time.
func _ready():
	handle_connecting_signals()

func handle_connecting_signals() -> void:
	Next.button_down.connect(_on_next_pressed)
	Back.button_down.connect(_on_back_pressed)


func _on_next_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Nux.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/GameRule2Nux.tscn")

class_name OptionsMenu
extends Control

@onready var exit_button = $MarginContainer/VBoxContainer/Exit as Button
signal exit_options_menu
# Called when the node enters the scene tree for the first time.
func _ready():
	exit_button.button_down.connect(_on_exit_pressed)
	set_process(false)

func _on_volume_value_changed(value):
	AudioServer.set_bus_volume_db(0,value/5)


func _on_mute_toggled(toggled_on):
	AudioServer.set_bus_mute(0,toggled_on)


func _on_exit_pressed() -> void:
	exit_options_menu.emit()
	set_process(false)
	

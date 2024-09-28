class_name MainMenu
extends Control

@onready var start_button = $"VBoxContainer/Start Button" as Button
@onready var nux_mode = $"VBoxContainer/Nux Mode" as Button
@onready var options_button = $VBoxContainer/Options as Button
@onready var exit_button = $VBoxContainer/Exit as Button
@onready var options_menu = $Options as OptionsMenu
@onready var vbox_container = $VBoxContainer as VBoxContainer
# Called when the node enters the scene tree for the first time.
func _ready():
	handle_connecting_signals()

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")


func _on_nux_pressed():
	get_tree().change_scene_to_file("res://Scenes/Nux.tscn")


func _on_options_pressed():
	vbox_container.visible = false
	$Options.set_process(true)
	$Options.visible = true


func _on_exit_pressed():
	get_tree().quit()

func _on_exit_options_menu() -> void:
	vbox_container.visible = true
	$Options.visible = false
	

func handle_connecting_signals() -> void:
	start_button.button_down.connect(_on_start_pressed)
	nux_mode.button_down.connect(_on_nux_pressed)
	exit_button.button_down.connect(_on_exit_pressed)
	options_menu.exit_options_menu.connect(_on_exit_options_menu)
	

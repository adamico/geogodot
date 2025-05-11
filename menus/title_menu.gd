extends Node2D

@onready var play_button: Button = %PlayButton
@onready var options_button: Button = %OptionsButton
@onready var quit_button: Button = %QuitButton
@onready var main_menu: CenterContainer = %MainMenu
@onready var settings: PanelContainer = %Settings

func _ready() -> void:
    play_button.pressed.connect(_play)
    options_button.pressed.connect(_show_options_menu)
    quit_button.pressed.connect(_quit)


func _play() -> void:
    get_tree().change_scene_to_file("res://main.tscn")


func _show_options_menu() -> void:
    main_menu.hide()
    settings.show()


func _quit() -> void:
    get_tree().quit()

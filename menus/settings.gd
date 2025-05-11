extends PanelContainer

@onready var apply: Button = %Apply
@onready var back: Button = %Back
@onready var settings: PanelContainer = %Settings
@onready var main_menu: CenterContainer = %MainMenu

func _ready() -> void:
    back.pressed.connect(_on_back_pressed)


func _on_back_pressed() -> void:
    settings.hide()
    main_menu.show()

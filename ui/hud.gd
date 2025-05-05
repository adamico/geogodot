extends Control

@export var players: Array[Player]

const HUD_LABEL = preload("res://ui/hud_label.tres")
const HUD_LABEL_OFF = preload("res://ui/hud_label_off.tres")
const RANK_1 = preload("res://assets/sprites/rank042.png")
const RANK_2 = preload("res://assets/sprites/rank043.png")
const RANK_3 = preload("res://assets/sprites/rank044.png")
const RANKS = [RANK_1, RANK_2, RANK_3]

@onready var percentage_value: Label = %PercentageValue
@onready var score_value: Label = %ScoreValue
@onready var capture_level: Label = %CaptureLevel
@onready var capture_level_2: Label = %CaptureLevel2
@onready var capture_level_3: Label = %CaptureLevel3
@onready var laser_level: Label = %LaserLevel
@onready var laser_level_2: Label = %LaserLevel2
@onready var laser_level_3: Label = %LaserLevel3

func _process(_delta: float) -> void:
    percentage_value.text = "%.1f%%" % Score.current_capture_percentage
    score_value.text = "%04d" % Score.score_values[1]
    ["capture_power", "laser_power"].map(process_labels_for)

func process_labels_for(stat_name) -> void:
    for player in players:
        var stat_value = player.stats_component.get(stat_name)
        var group_name = stat_name + "_p" + str(player.number+1) 
        var stat_labels = get_tree().get_nodes_in_group(group_name)
        for i in range(stat_value):
            var stat_label = stat_labels[i] as Label
            stat_label.set_label_settings(HUD_LABEL)

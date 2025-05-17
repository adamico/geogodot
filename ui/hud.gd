extends Control

const RANK_1 = preload("res://assets/sprites/rank041.png")
const RANK_2 = preload("res://assets/sprites/rank042.png")
const RANK_3 = preload("res://assets/sprites/rank043.png")
const RANK_4 = preload("res://assets/sprites/rank044.png")
const RANKS = [null, RANK_1, RANK_2, RANK_3, RANK_4]
const POWER_BAR_FILL_STYLE = preload("res://ui/power_bar_fill_style.tres")
const POWER_BAR_FILL_STYLE_MAX = preload("res://ui/power_bar_fill_style_max.tres")

@export var game_timer: Timer

var players: Array[Node]


@onready var percentage_value: Label = %PercentageValue
@onready var score_value: Label = %ScoreValue
@onready var game_timer_value: Label = %GameTimerValue
@onready var root_node: Node = $".."


func _ready() -> void:
    players = get_tree().get_nodes_in_group("players")


func _process(_delta: float) -> void:
    percentage_value.text = "%.0f%%" % Score.current_capture_percentage
    score_value.text = "%06d" % Score.score_values[1]
    ["capture_power", "laser_power"].map(_process_labels_for)
    var time_string = Time.get_time_string_from_unix_time(root_node.elapsed_time)
    game_timer_value.text = time_string.substr(3)#"{minute}:{second}".format(time_dict)


func _process_labels_for(stat_name) -> void:
    for player in players:
        if not player: return
        var shards_value = player.stats_component.get(stat_name + "_shards")
        var rank_value = player.stats_component.get(stat_name)
        var group_name: String = stat_name + "_p" + str(player.number + 1)
        var rank_texture_rect: TextureRect = get_node("%Rank" + group_name.to_pascal_case())
        rank_texture_rect.texture = RANKS[rank_value]
        var progress_bar_node_path = "%" + stat_name.to_pascal_case() + "BarP" + str(player.number + 1)
        var progress_bar: ProgressBar = get_node(progress_bar_node_path)
        if rank_value < Constants.POWER_RANKS:
            progress_bar.value = shards_value
            progress_bar.add_theme_stylebox_override("fill", POWER_BAR_FILL_STYLE)
        else:
            progress_bar.value = Constants.POWER_SHARDS
            progress_bar.add_theme_stylebox_override("fill", POWER_BAR_FILL_STYLE_MAX)

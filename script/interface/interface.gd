class_name Interface
extends Control


@export_node_path("StationListPanel") var _station_list_panel_node_path: NodePath
@export_node_path("LevelCompletePopup") var _level_complete_popup_path: NodePath
@export_node_path("LevelListPopup") var _level_list_popup_path: NodePath

@onready var _station_list_panel: StationListPanel = get_node(_station_list_panel_node_path)
@onready var _level_complete_popup: LevelCompletePopup = get_node(_level_complete_popup_path)
@onready var _level_list_popup: LevelListPopup = get_node(_level_list_popup_path)


func _ready() -> void:
	Events.level_start_request.connect(_on_level_start_request)
	Events.level_started.connect(_on_level_started)
	Events.level_completed.connect(_on_level_completed)
	Events.home_return_request.connect(_on_home_return_request)


func _on_level_start_request(level_id: String) -> void:
	var level_resource: LevelResource = Levels.get_resource_by_id(level_id)
	_station_list_panel.init(level_resource.stations)


func _on_level_started(_level_id: String) -> void:
	_level_complete_popup.hide()
	_level_list_popup.hide()


func _on_level_completed(_level_id: String, _stars: int) -> void:
	_level_complete_popup.show()


func _on_home_return_request() -> void:
	_level_complete_popup.hide()
	_level_list_popup.show()

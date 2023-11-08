class_name Interface
extends Control


@export_node_path("StationListPanel") var _station_list_panel_node_path: NodePath

@onready var _station_list_panel: StationListPanel = get_node(_station_list_panel_node_path)


func _ready() -> void:
	Events.level_start_request.connect(_on_level_start_request)


func _on_level_start_request(level_id: String) -> void:
	var level_resource: LevelResource = Levels.get_resource_by_id(level_id)
	_station_list_panel.init(level_resource.stations)

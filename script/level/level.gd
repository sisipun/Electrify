class_name Level
extends Area2D


@export_node_path("Station") var _station_path: NodePath
@export_node_path("Node2D") var _stations_node_path: NodePath 
@export_node_path("Node2D") var _buildings_node_path: NodePath 

@onready var _station: Station = get_node(_station_path)
@onready var _stations_node: Node2D = get_node(_stations_node_path)
@onready var _buildings_node: Node2D = get_node(_buildings_node_path)

var _stations: Array[Station]
var _buildings: Array[Building]


func _ready() -> void:
	_on_window_size_changed()
	get_viewport().size_changed.connect(_on_window_size_changed)
	
	_station.init(256)
	
	_stations = []
	for station in _stations_node.get_children():
		station.building_entered.connect(Callable(_on_station_building_entered).bind(station))
		if _station != station:
			station.init(128)
		_stations.append(station)
	
	_buildings = []
	for building in _buildings_node.get_children():
		_buildings.append(building)
	
	


func is_completed() -> bool:
	for building in _buildings:
		if not building.is_active():
			return false
	return true


func _on_window_size_changed() -> void:
	position = get_viewport_rect().size / 2


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventScreenTouch and event.is_pressed():
		_station.global_position = event.position


func _on_station_building_entered(_building: Building, _station: Station) -> void:
	if is_completed():
		print('completed')

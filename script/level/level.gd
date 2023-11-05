class_name Level
extends Area2D


@export_node_path("CollisionShape2D") var _shape_path: NodePath
@export_node_path("Node2D") var _stations_node_path: NodePath 
@export_node_path("Node2D") var _buildings_node_path: NodePath
@export_node_path("Node2D") var _points_node_path: NodePath
@export var _station_scene: PackedScene

@onready var _shape: CollisionShape2D = get_node(_shape_path)
@onready var _stations_node: Node2D = get_node(_stations_node_path)
@onready var _buildings_node: Node2D = get_node(_buildings_node_path)
@onready var _points_node: Node2D = get_node(_points_node_path)

var _stations: Array[Station]
var _buildings: Array[Building]
var _points: Array[StationPoint]
var _selected_station: Station


func _ready() -> void:
	_on_window_size_changed()
	get_viewport().size_changed.connect(_on_window_size_changed)
	
	_stations = []
	_buildings = []
	for building in _buildings_node.get_children():
		_buildings.append(building)
	_points = []
	for point in _points_node.get_children():
		_points.append(point)
	
	_selected_station = null


func is_completed() -> bool:
	for building in _buildings:
		if not building.is_active():
			return false
	return true


func can_drop(_global_position: Vector2, _data: Variant) -> bool:
	return get_point(_global_position) != null


func drop(_global_position: Vector2, _data: Variant) -> void:
	var station: Station = _station_scene.instantiate()
	_stations_node.add_child(station)
	_stations.append(station)
	station.pressed.connect(Callable(_on_station_pressed).bind(station))
	station.building_entered.connect(Callable(_on_station_building_entered).bind(station))
	station.init(to_local(_global_position), 256)
	get_point(_global_position).add_station(station)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and not event.pressed:
		_on_station_released()
	if event is InputEventScreenDrag and _selected_station:
		var new_position = _selected_station.position + event.relative
		
		var size: Vector2 = _shape.shape.get_rect().size / 2
		if _selected_station.position.x > size.x:
			_selected_station.position.x = size.x
		elif _selected_station.position.x < -size.x:
			_selected_station.position.x = -size.x
		
		if _selected_station.position.y > size.y:
			_selected_station.position.y = size.y
		elif _selected_station.position.y < -size.y:
			_selected_station.position.y = -size.y
		
		_selected_station.move_to(new_position)


func _on_window_size_changed() -> void:
	position = get_viewport_rect().size / 2


func _on_station_pressed(station: Station) -> void:
	if not _selected_station:
		_selected_station = station


func _on_station_released() -> void:
	if _selected_station:
		_selected_station = null


func _on_station_building_entered(_building: Building, _station: Station) -> void:
	if is_completed():
		print('completed')


func get_point(_global_position: Vector2) -> StationPoint:
	for point in _points:
		if point.can_add_station(_global_position):
			return point
	return null

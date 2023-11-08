class_name Level
extends Area2D


@export_node_path("CollisionShape2D") var _shape_path: NodePath
@export_node_path("Node2D") var _stations_node_path: NodePath 
@export_node_path("Node2D") var _buildings_node_path: NodePath
@export_node_path("Node2D") var _spots_node_path: NodePath
@export var _station_scene: PackedScene
@export var _building_scene: PackedScene
@export var _spot_scene: PackedScene

@onready var _shape: CollisionShape2D = get_node(_shape_path)
@onready var _stations_node: Node2D = get_node(_stations_node_path)
@onready var _buildings_node: Node2D = get_node(_buildings_node_path)
@onready var _spots_node: Node2D = get_node(_spots_node_path)

var _stations: Array[Station]
var _buildings: Array[Building]
var _spots: Array[Spot]
var _selected_station: Station


func _ready() -> void:
	_on_window_size_changed()
	get_viewport().size_changed.connect(_on_window_size_changed)
	Events.level_start_request.connect(_on_level_start_request)
	_stations = []
	_buildings = []
	_spots = []
	_selected_station = null


func is_completed() -> bool:
	for building in _buildings:
		if not building.is_active():
			return false
	return true


func can_drop(_global_position: Vector2, _data: Variant) -> bool:
	return get_spot(_global_position) != null


func drop(_global_position: Vector2, _data: Variant) -> void:
	var station: Station = _station_scene.instantiate()
	_stations_node.add_child(station)
	_stations.append(station)
	station.pressed.connect(Callable(_on_station_pressed).bind(station))
	station.building_entered.connect(Callable(_on_station_building_entered).bind(station))
	station.init(to_local(_global_position), 256)
	get_spot(_global_position).add_station(station)


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


func _on_level_start_request(level_id: String) -> void:
	var level_resource: LevelResource = Levels.get_resource_by_id(level_id)
	for level_building_resource in level_resource.buildings:
		var building_resource: BuildingResource = Buildings.get_resource_by_type(level_building_resource.type)
		var building: Building = _building_scene.instantiate()
		_buildings_node.add_child(building)
		building.init(level_building_resource.position, building_resource.power_to_activate)
		_buildings.append(building)
	
	for level_spot_resource in level_resource.spots:
		var _spot_resource: SpotResource = Spots.get_resource_by_type(level_spot_resource.type)
		var spot: Spot = _spot_scene.instantiate()
		_spots_node.add_child(spot)
		spot.init(level_spot_resource.position)
		_spots.append(spot)


func _on_station_pressed(station: Station) -> void:
	if not _selected_station:
		_selected_station = station


func _on_station_released() -> void:
	if _selected_station:
		_selected_station = null


func _on_station_building_entered(_building: Building, _station: Station) -> void:
	if is_completed():
		print('completed')


func get_spot(_global_position: Vector2) -> Spot:
	for spot in _spots:
		if spot.can_add_station(_global_position):
			return spot
	return null

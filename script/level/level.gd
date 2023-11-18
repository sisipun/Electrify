class_name Level
extends Area2D


signal dragged(data)


@export_node_path("Node2D") var _stations_node_path: NodePath 
@export_node_path("Node2D") var _buildings_node_path: NodePath
@export_node_path("Node2D") var _spots_node_path: NodePath
@export var _station_scene: PackedScene
@export var _building_scene: PackedScene
@export var _spot_scene: PackedScene

@onready var _stations_node: Node2D = get_node(_stations_node_path)
@onready var _buildings_node: Node2D = get_node(_buildings_node_path)
@onready var _spots_node: Node2D = get_node(_spots_node_path)

var _level_id: String
var _selected_station: Station


func _ready() -> void:
	_on_window_size_changed()
	get_viewport().size_changed.connect(_on_window_size_changed)
	Events.level_start_request.connect(_on_level_start_request)


func is_completed() -> bool:
	for building in _buildings_node.get_children():
		if not building.is_active():
			return false
	return true


func can_drop(_global_position: Vector2, _drag_data: Variant, _drag_zone: Node) -> bool:
	return _get_spot(_global_position) != null


func drop(_global_position: Vector2, drag_data: Variant, _drag_zone: Node) -> void:
	if drag_data is StationDefinition:
		var type: StationModel.Type = drag_data.get_type()
		var station_resource: StationResource = Stations.get_resource_by_type(type)
		var station: Station = _station_scene.instantiate()
		_stations_node.add_child(station)
		station.building_entered.connect(Callable(_on_station_building_entered).bind(station))
		station.init(
			to_local(_global_position), 
			station_resource.sprite_frames,
			station_resource.radius
		)
		_get_spot(_global_position).add_station(station)
	if drag_data is Spot:
		var spot: Spot = drag_data
		var new_spot: Spot = _get_spot(_global_position)
		var station: Station = spot.get_station()
		spot.remove_station()
		new_spot.add_station(station)


func clear() -> void:
	for spot in _spots_node.get_children():
		spot.queue_free()
	for building in _buildings_node.get_children():
		building.queue_free()
	for station in _stations_node.get_children():
		station.queue_free()
	_selected_station = null


func start(level_id: String) -> void:
	_level_id = level_id
	var level_resource: LevelResource = Levels.get_resource_by_id(level_id)
	for level_building_resource in level_resource.buildings:
		var building_resource: BuildingResource = Buildings.get_resource_by_type(level_building_resource.type)
		var building: Building = _building_scene.instantiate()
		_buildings_node.add_child(building)
		building.init(
			level_building_resource.position, 
			building_resource.sprite_frames, 
			building_resource.power_to_activate
		)
	
	for level_spot_resource in level_resource.spots:
		var spot_resource: SpotResource = Spots.get_resource_by_type(level_spot_resource.type)
		var spot: Spot = _spot_scene.instantiate()
		_spots_node.add_child(spot)
		spot.dragged.connect(Callable(_on_spot_dragged).bind(spot))
		spot.init(
			level_spot_resource.position, 
			spot_resource.sprite_frames
		)
	
	Events.emit_signal("level_started", _level_id)


func _on_window_size_changed() -> void:
	position = get_viewport_rect().size / 2


func _on_level_start_request(level_id: String) -> void:
	clear()
	start(level_id)


func _on_spot_dragged(spot: Spot) -> void:
	if spot.has_station():
		emit_signal("dragged", spot)


func _on_station_building_entered(_building: Building, _station: Station) -> void:
	if is_completed():
		Events.emit_signal("level_completed", _level_id, 3)


func _get_spot(_global_position: Vector2) -> Spot:
	for spot in _spots_node.get_children():
		if spot.can_add_station(_global_position):
			return spot
	return null

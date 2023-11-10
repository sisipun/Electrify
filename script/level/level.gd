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

var _level_id: String
var _selected_station: Station


func _ready() -> void:
	_on_window_size_changed()
	get_viewport().size_changed.connect(_on_window_size_changed)
	Events.level_start_request.connect(_on_level_start_request)
	_selected_station = null


func is_completed() -> bool:
	for building in _buildings_node.get_children():
		if not building.is_active():
			return false
	return true


func can_drop(_global_position: Vector2, _data: Variant) -> bool:
	return _get_spot(_global_position) != null


func drop(_global_position: Vector2, _data: Variant) -> void:
	var type: StationModel.Type = _data["type"]
	var station_resource: StationResource = Stations.get_resource_by_type(type)
	var station: Station = _station_scene.instantiate()
	_stations_node.add_child(station)
	station.pressed.connect(Callable(_on_station_pressed).bind(station))
	station.building_entered.connect(Callable(_on_station_building_entered).bind(station))
	station.init(
		to_local(_global_position), 
		station_resource.sprite_frames,
		station_resource.radius
	)
	_get_spot(_global_position).add_station(station)


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
		spot.init(
			level_spot_resource.position, 
			spot_resource.sprite_frames
		)


func _on_station_pressed(station: Station) -> void:
	if not _selected_station:
		_selected_station = station


func _on_station_released() -> void:
	if _selected_station:
		_selected_station = null


func _on_station_building_entered(_building: Building, _station: Station) -> void:
	if is_completed():
		Events.emit_signal("level_completed", _level_id)


func _get_spot(_global_position: Vector2) -> Spot:
	for spot in _spots_node.get_children():
		if spot.can_add_station(_global_position):
			return spot
	return null

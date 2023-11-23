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

var _level_model: LevelModel


func _ready() -> void:
	_on_window_size_changed()
	get_viewport().size_changed.connect(_on_window_size_changed)
	Events.level_start_request.connect(_on_level_start_request)


func clear() -> void:
	for spot in _spots_node.get_children():
		spot.queue_free()
	for building in _buildings_node.get_children():
		building.queue_free()
	for station in _stations_node.get_children():
		station.queue_free()


func start(level_id: String) -> void:
	_level_model = Levels.get_model_by_id(level_id)
	_level_model.finished.connect(Callable(_on_level_finished).bind(level_id))
	for building_model in _level_model.get_buildings():
		var building_resource: BuildingResource = Buildings.get_resource_by_type(building_model.get_type())
		var building: Building = _building_scene.instantiate()
		_buildings_node.add_child(building)
		building.init(
			building_model.get_position(), 
			building_resource.sprite_frames, 
			building_resource.power_to_activate
		)
		building.activated.connect(Callable(building_model, "activate"))
		building.deactivated.connect(Callable(building_model, "deactivate"))
	
	for spot_model in _level_model.get_spots():
		var spot_resource: SpotResource = Spots.get_resource_by_type(spot_model.get_type())
		var spot: Spot = _spot_scene.instantiate()
		_spots_node.add_child(spot)
		spot.dragged.connect(Callable(_on_spot_dragged).bind(spot))
		spot.init(
			spot_model.get_position(), 
			spot_resource.sprite_frames
		)
		spot.station_added.connect(Callable(spot_model, "add_station"))
		spot.station_removed.connect(Callable(spot_model, "remove_station"))
	
	Events.emit_signal("level_started", level_id)


func can_drop(_global_position: Vector2, _drag_data: Variant, _drag_zone: Node) -> bool:
	return _get_spot(_global_position) != null


func drop(_global_position: Vector2, drag_data: Variant, _drag_zone: Node) -> void:
	if drag_data is StationDefinition:
		var type: StationModel.Type = drag_data.get_type()
		var station_resource: StationResource = Stations.get_resource_by_type(type)
		var station: Station = _station_scene.instantiate()
		_stations_node.add_child(station)
		station.init(
			type,
			to_local(_global_position), 
			station_resource.sprite_frames,
			station_resource.radius
		)
		_get_spot(_global_position).add_station(station)
		_level_model.spawn_station(type)
	if drag_data is Spot:
		var spot: Spot = drag_data
		var new_spot: Spot = _get_spot(_global_position)
		var station: Station = spot.get_station()
		spot.remove_station()
		new_spot.add_station(station)


func drag_canceled(drag_data: Variant, _drag_zone: Node) -> void:
	if drag_data is Spot:
		var station: Station = drag_data.get_station()
		var station_type: StationModel.Type = station.get_type()
		_level_model.return_station(station_type)
		station.queue_free()


func _on_window_size_changed() -> void:
	position = get_viewport_rect().size / 2


func _on_level_start_request(level_id: String) -> void:
	clear()
	start(level_id)


func _on_spot_dragged(spot: Spot) -> void:
	if spot.has_station():
		emit_signal("dragged", spot)


func _on_level_finished(stars: int, level_id: String) -> void:
	Events.emit_signal("level_completed", level_id, stars)


func _get_spot(_global_position: Vector2) -> Spot:
	for spot in _spots_node.get_children():
		if spot.can_add_station(_global_position):
			return spot
	return null

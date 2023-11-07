class_name Spot
extends Area2D


@export_node_path("CollisionShape2D") var _shape_node_path: NodePath

@onready var _shape: CollisionShape2D = get_node(_shape_node_path)

var _station: Station


func _ready() -> void:
	_station = null


func init(_position: Vector2) -> void:
	position = _position


func can_add_station(_global_position: Vector2) -> bool:
	return not _station and _shape.shape.get_rect().has_point(to_local(_global_position))


func add_station(station: Station) -> void:
	_station = station
	_station.move_to(position)

class_name Spot
extends Area2D


signal dragged


@export_node_path("CollisionShape2D") var _shape_node_path: NodePath
@export_node_path("AnimatedSprite2D") var _body_node_path: NodePath

@onready var _shape: CollisionShape2D = get_node(_shape_node_path)
@onready var _body: AnimatedSprite2D = get_node(_body_node_path)

var _station: Station


func _ready() -> void:
	_station = null


func init(_position: Vector2, sprite_frames: SpriteFrames) -> void:
	position = _position
	_body.sprite_frames = sprite_frames


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventScreenDrag:
		emit_signal("dragged")


func has_station() -> bool:
	return _station != null


func can_add_station(_global_position: Vector2) -> bool:
	return not _station and _shape.shape.get_rect().has_point(to_local(_global_position))


func get_station() -> Station:
	return _station


func add_station(station: Station) -> void:
	_station = station
	_station.move_to(position)


func remove_station() -> void:
	_station = null

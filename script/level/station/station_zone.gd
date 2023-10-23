class_name StationZone
extends Area2D


@export_node_path("CollisionShape2D") var _shape_path: NodePath
@export_node_path("Sprite2D") var _body_path: NodePath

@onready var _shape: CollisionShape2D = get_node(_shape_path)
@onready var _body: Sprite2D = get_node(_body_path)


func init(radius: float) -> void:
	var _scale = radius / _shape.shape.radius
	_body.scale = Vector2(_scale, _scale)
	_shape.shape.radius = radius

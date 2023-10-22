class_name Station
extends Area2D


@export_node_path("CollisionShape2D") var _shape_path: NodePath
@export_node_path("Sprite2D") var _zone_path: NodePath

@onready var _shape: CollisionShape2D = get_node(_shape_path)
@onready var _zone: Sprite2D = get_node(_zone_path)


func init(radius: float) -> void:
	var scale = radius / _shape.shape.radius
	_zone.scale = Vector2(scale, scale)
	_shape.shape.radius = radius

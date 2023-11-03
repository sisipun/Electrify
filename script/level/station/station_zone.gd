class_name StationZone
extends Area2D


signal building_entered(building)
signal building_exited(building)


@export_node_path("CollisionShape2D") var _shape_path: NodePath
@export_node_path("Sprite2D") var _body_path: NodePath

@onready var _shape: CollisionShape2D = get_node(_shape_path)
@onready var _body: Sprite2D = get_node(_body_path)


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func init(radius: float) -> void:
	var _scale = radius / _shape.shape.radius
	_body.scale = Vector2(_scale, _scale)
	_shape.shape.radius = radius


func _on_area_entered(area: Area2D) -> void:
	if area is Building:
		emit_signal("building_entered", area as Building)


func _on_area_exited(area: Area2D) -> void:
	if area is Building:
		emit_signal("building_exited", area as Building)

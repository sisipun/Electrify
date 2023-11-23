class_name Building
extends Area2D


signal activated
signal deactivated


@export_node_path("AnimatedSprite2D") var _body_path: NodePath
@export_node_path("AnimatedSprite2D") var _effect_path: NodePath

@onready var _body: AnimatedSprite2D = get_node(_body_path)
@onready var _effect: AnimatedSprite2D = get_node(_effect_path)

var _power_to_activate: int
var _power: int


func _ready() -> void:
	_power = 0


func init(_position: Vector2, sprite_frames: SpriteFrames, power_to_activate: int) -> void:
	position = _position
	_body.sprite_frames = sprite_frames
	_power_to_activate = power_to_activate


func is_active() -> bool:
	return _power >= _power_to_activate


func increase_power(value: int) -> void:
	_power += value
	if is_active():
		_body.play("active")
		emit_signal("activated")


func decrease_power(value: int) -> void:
	_power -= value
	if not is_active():
		_body.play("default")
		emit_signal("deactivated")


func show_preview_effect() -> void:
	_effect.play("preview")


func show_default_effect() -> void:
	_effect.play("default")

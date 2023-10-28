class_name Building
extends Area2D


@export_node_path("AnimatedSprite2D") var _body_path: NodePath
@export_node_path("AnimatedSprite2D") var _effect_path: NodePath

@export_range(1, 10) var _power_to_active: int

@onready var _body: AnimatedSprite2D = get_node(_body_path)
@onready var _effect: AnimatedSprite2D = get_node(_effect_path)

var _power: int


func _ready() -> void:
	_power = 0
	_show_inactive()
	show_default_effect()


func is_active() -> bool:
	return _power >= _power_to_active


func increase_power(value: int) -> void:
	_power += value
	if is_active():
		_show_active()


func decrease_power(value: int) -> void:
	_power -= value
	if not is_active():
		_show_inactive()


func show_preview_effect() -> void:
	_effect.play("preview")


func show_default_effect() -> void:
	_effect.play("default")


func _show_active() -> void:
	_body.play("active")


func _show_inactive() -> void:
	_body.play("default")

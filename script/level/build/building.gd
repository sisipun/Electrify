class_name Building
extends Area2D


@export_node_path("AnimatedSprite2D") var _body_path: NodePath
@export_node_path("AnimatedSprite2D") var _effect_path: NodePath

@onready var _body: AnimatedSprite2D = get_node(_body_path)
@onready var _effect: AnimatedSprite2D = get_node(_effect_path)

var _active: bool


func _ready() -> void:
	deactivate()
	show_default()


func activate() -> void:
	_active = true
	_body.play("active")


func deactivate() -> void:
	_active = false
	_body.play("default")


func show_preview() -> void:
	_effect.play("preview")


func show_default() -> void:
	_effect.play("default")

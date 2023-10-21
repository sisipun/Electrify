class_name Level
extends Area2D


func _ready() -> void:
	_on_window_size_changed()
	get_viewport().size_changed.connect(_on_window_size_changed)


func _on_window_size_changed() -> void:
	position = get_viewport_rect().size / 2

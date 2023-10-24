class_name Level
extends Area2D


@export_node_path("Station") var _station_path: NodePath

@onready var _station: Station = get_node(_station_path)


func _ready() -> void:
	_on_window_size_changed()
	get_viewport().size_changed.connect(_on_window_size_changed)
	
	_station.init(256)


func _on_window_size_changed() -> void:
	position = get_viewport_rect().size / 2


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventScreenTouch and event.is_pressed():
		_station.global_position = event.position

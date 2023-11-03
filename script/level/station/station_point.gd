class_name StationPoint
extends Area2D


var entered_station: Station


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	entered_station = null


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventScreenTouch and not event.pressed and entered_station:
		entered_station.move_to(position)


func _on_area_entered(area: Area2D) -> void:
	if not entered_station and area is Station:
		entered_station = area


func _on_area_exited(area: Area2D) -> void:
	if entered_station and area == entered_station:
		entered_station = null

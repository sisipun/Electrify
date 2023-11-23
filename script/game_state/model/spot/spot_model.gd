class_name SpotModel
extends Node


enum Type {
	LAND,
	WATER
}


signal station_added
signal station_removed


var _type: Type
var _position: Vector2
var _station: bool


func _init(type: Type, position: Vector2) -> void:
	_type = type
	_position = position
	_station = false


func get_type() -> Type:
	return _type


func get_position() -> Vector2:
	return _position


func has_station() -> bool:
	return _station


func add_station() -> void:
	_station = true
	emit_signal("station_added")


func remove_station() -> void:
	_station = false
	emit_signal("station_removed")

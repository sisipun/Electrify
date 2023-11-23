class_name BuildingModel
extends Object


enum Type {
	DEFAULT,
	ENERGY_INEFFICIENT
}


signal activated
signal deactivated


var _type: Type
var _position: Vector2
var _active: bool


func _init(type: Type, position: Vector2) -> void:
	_type = type
	_position = position
	_active = false


func get_type() -> Type:
	return _type


func get_position() -> Vector2:
	return _position


func is_active() -> bool:
	return _active


func activate() -> void:
	_active = true
	emit_signal("activated")


func deactivate() -> void:
	_active = false
	emit_signal("deactivated")

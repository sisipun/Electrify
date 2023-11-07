class_name LevelStorage
extends Node


@export var _levels: Array[LevelResource]

var _current_level_id: String
var _id_to_level: Dictionary = {}
var _level_ids: Array[String] = []


func _ready() -> void:
	for level in _levels:
		_id_to_level[level.id] = level
		_level_ids.append(level.id)
	_current_level_id = _level_ids[0]


func get_resource_by_id(id: String) -> LevelResource:
	return _id_to_level[id]


func get_current_level_id() -> String:
	return _current_level_id

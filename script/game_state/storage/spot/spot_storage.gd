class_name SpotStorage
extends Node


@export var land: SpotResource
@export var water: SpotResource

@onready var _spots: Dictionary = {
	SpotModel.Type.LAND: land,
	SpotModel.Type.WATER: water
}


func get_resource_by_type(type: SpotModel.Type) -> SpotResource:
	return _spots[type]

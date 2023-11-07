class_name BuildingStorage
extends Node


@export var default: BuildingResource
@export var energy_inefficient: BuildingResource

@onready var _buildings: Dictionary = {
	BuildingModel.Type.DEFAULT: default,
	BuildingModel.Type.ENERGY_INEFFICIENT: energy_inefficient
}


func get_resource_by_type(type: BuildingModel.Type) -> BuildingResource:
	return _buildings[type]

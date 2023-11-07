class_name StationStorage
extends Node


@export var default: StationResource
@export var powerfull: StationResource
@export var wide: StationResource

@onready var _stations: Dictionary = {
	StationModel.Type.DEFAULT: default,
	StationModel.Type.POWERFULL: powerfull,
	StationModel.Type.WIDE: wide
}


func get_resource_by_type(type: StationModel.Type) -> StationResource:
	return _stations[type]

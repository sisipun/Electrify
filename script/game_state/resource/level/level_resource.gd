class_name LevelResource
extends Resource


@export var id: String
@export var _two_star_condition: int
@export var _three_star_condition: int
@export var stations: Array[LevelStationResource]
@export var buildings: Array[LevelBuildingResource]
@export var spots: Array[LevelSpotResource]


func get_two_star_condition() -> int:
	return _two_star_condition


func get_three_star_condition() -> int:
	return max(_three_star_condition, get_two_star_condition())

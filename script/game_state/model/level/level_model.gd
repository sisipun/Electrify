class_name LevelModel
extends Object


var _level_id: String
var _two_star_condition: int
var _three_star_condition: int
var _stations_left: Dictionary


func _init(
	level_id: String,
	two_star_condition: int,
	three_star_condition: int,
	stations: Array[LevelStationResource]
) -> void:
	_level_id = level_id
	_two_star_condition = two_star_condition
	_three_star_condition = three_star_condition
	_stations_left = {}
	for station in stations:
		_stations_left[station.type] = station.count


func get_level_id() -> String:
	return _level_id


func get_stars() -> int:
	var stations_left_count: int = get_stations_left_count()
	if stations_left_count >= _three_star_condition:
		return 3
	elif stations_left_count >= _two_star_condition:
		return 2
	else:
		return 1 


func get_stations_left_count() -> int:
	return _stations_left.values().reduce(func(x, y): return x + y, 0)


func spawn_station(type: StationModel.Type) -> void:
	_stations_left[type] -= 1


func return_station(type: StationModel.Type) -> void:
	_stations_left[type] += 1

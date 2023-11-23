class_name LevelModel
extends Object


signal finished(stars)


var _two_star_condition: int
var _three_star_condition: int

var _stations_left: Dictionary
var _buildings: Array[BuildingModel]
var _spots: Array[SpotModel]


func _init(
	two_star_condition: int,
	three_star_condition: int,
	stations: Array[LevelStationResource],
	buildings: Array[LevelBuildingResource],
	spots: Array[LevelSpotResource]
) -> void:
	_two_star_condition = two_star_condition
	_three_star_condition = three_star_condition
	_stations_left = {}
	for station in stations:
		_stations_left[station.type] = station.count
	_buildings = []
	for building in buildings:
		var building_model: BuildingModel = BuildingModel.new(building.type, building.position)
		building_model.activated.connect(_on_building_activated)
		_buildings.append(building_model)
	_spots = []
	for spot in spots:
		var spot_model: SpotModel = SpotModel.new(spot.type, spot.position)
		_spots.append(spot_model)


func get_buildings() -> Array[BuildingModel]:
	return _buildings


func get_spots() -> Array[SpotModel]:
	return _spots


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


func _on_building_activated() -> void:
	if _buildings.all(func(it): return it.is_active()):
		emit_signal("finished", get_stars())

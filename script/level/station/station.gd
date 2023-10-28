class_name Station
extends Area2D


@export_node_path("StationZone") var _zone_path: NodePath

@export_range(1, 10) var _power: int

@onready var _zone: StationZone = get_node(_zone_path)

var buildings: Array[Building] = []


func init(zone_radius: float) -> void:
	_zone.init(zone_radius)
	
	_zone.building_entered.connect(_on_building_entered)
	_zone.building_exited.connect(_on_building_exited)


func _on_building_entered(building: Building) -> void:
	buildings.append(building)
	building.increase_power(_power)


func _on_building_exited(building: Building) -> void:
	building.decrease_power(_power)
	buildings.remove_at(buildings.find(building))

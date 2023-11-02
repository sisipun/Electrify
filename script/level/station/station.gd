class_name Station
extends Area2D


signal pressed
signal building_entered(building)
signal building_exited(building)


@export_node_path("StationZone") var _zone_path: NodePath

@export_range(1, 10) var _power: int

@onready var _zone: StationZone = get_node(_zone_path)

var buildings: Array[Building]


func _ready() -> void:
	buildings = []


func init(zone_radius: float) -> void:
	_zone.init(zone_radius)
	
	_zone.building_entered.connect(_on_building_entered)
	_zone.building_exited.connect(_on_building_exited)


func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventScreenTouch and event.pressed:
		emit_signal("pressed")


func _on_building_entered(building: Building) -> void:
	buildings.append(building)
	building.increase_power(_power)
	emit_signal("building_entered", building)


func _on_building_exited(building: Building) -> void:
	building.decrease_power(_power)
	buildings.remove_at(buildings.find(building))
	emit_signal("building_exited", building)

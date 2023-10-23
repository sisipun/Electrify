class_name Station
extends Area2D


@export_node_path("StationZone") var _zone_path: NodePath

@onready var _zone: StationZone = get_node(_zone_path)


func init(zone_radius: float) -> void:
	_zone.init(zone_radius)

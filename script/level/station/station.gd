class_name Station
extends Area2D


signal building_entered(building)
signal building_exited(building)


@export_node_path("AnimatedSprite2D") var _body_node_path: NodePath
@export_node_path("StationZone") var _zone_path: NodePath

@export_range(1, 10) var _power: int

@onready var _body: AnimatedSprite2D = get_node(_body_node_path)
@onready var _zone: StationZone = get_node(_zone_path)

var buildings: Array[Building]


func _ready() -> void:
	buildings = []


func init(_position: Vector2, sprite_frames: SpriteFrames, zone_radius: float) -> void:
	position = _position
	_body.sprite_frames = sprite_frames
	
	_zone.init(zone_radius)
	_zone.building_entered.connect(_on_building_entered)
	_zone.building_exited.connect(_on_building_exited)


func move_to(new_position: Vector2) -> void:
	position = new_position


func _on_building_entered(building: Building) -> void:
	buildings.append(building)
	building.increase_power(_power)
	emit_signal("building_entered", building)


func _on_building_exited(building: Building) -> void:
	building.decrease_power(_power)
	buildings.remove_at(buildings.find(building))
	emit_signal("building_exited", building)

class_name StationListPanel
extends Control


signal dragged(data)


@export_node_path("Control") var _definitions_node_path: NodePath
@export var _definition_scene: PackedScene

@onready var _definitions_node: Control = get_node(_definitions_node_path)


func init(level_station_resources: Array[LevelStationResource]) -> void:
	clear()
	for level_station_resource in level_station_resources:
		var definition: StationDefinition = _definition_scene.instantiate()
		var station_resource: StationResource = Stations.get_resource_by_type(level_station_resource.type)
		_definitions_node.add_child(definition)
		definition.dragged.connect(Callable(_on_definition_dragged).bind(definition))
		definition.init(
			level_station_resource.type, 
			station_resource.definition_image, 
			level_station_resource.count
		)


func clear() -> void:
	for definition in _definitions_node.get_children():
		definition.queue_free()


func drag_started(data: Variant) -> void:
	if data is StationDefinition:
		data.drag_started()


func drag_canceled(data: Variant) -> void:
	if data is StationDefinition:
		data.drag_canceled()


func dropped(data: Variant) -> void:
	if data is StationDefinition:
		data.dropped()


func _on_definition_dragged(definition: StationDefinition) -> void:
	emit_signal("dragged", definition)

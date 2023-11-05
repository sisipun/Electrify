class_name StationListPanel
extends Control


signal dragged(data)


@export_node_path("Control") var _definitions_node_path: NodePath

@onready var _definitions_node: Control = get_node(_definitions_node_path)


func _ready() -> void:
	for definition in _definitions_node.get_children():
		definition.dragged.connect(Callable(_on_definition_dragged).bind(definition))


func drag_started(data: Dictionary) -> void:
	data["definition"].drag_started()


func drag_canceled(data: Dictionary) -> void:
	data["definition"].drag_canceled()


func dropped(data: Dictionary) -> void:
	data["definition"].dropped()


func _on_definition_dragged(definition: StationDefinition) -> void:
	var data = {}
	data["definition"] = definition
	emit_signal("dragged", data)

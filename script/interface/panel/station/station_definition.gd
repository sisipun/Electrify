class_name StationDefinition
extends Panel


signal dragged


@export_node_path("Label") var _count_label_node_path: NodePath

@onready var _count_label: Label = get_node(_count_label_node_path)

var _count:
	set(value):
		_count = value
		_count_label.text = str(value)


func _ready() -> void:
	_count = 4


func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		emit_signal("dragged")


func drag_started() -> void:
	_count -= 1


func drag_canceled() -> void:
	_count += 1


func dropped() -> void:
	pass

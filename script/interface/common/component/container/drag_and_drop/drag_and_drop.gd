class_name DragAndDropp
extends Node


@export_node_path("Node") var _drag_zone_path: NodePath
@export_node_path("Node") var _drop_zone_path: NodePath

@onready var _drag_zone: Node = get_node(_drag_zone_path)
@onready var _drop_zone: Node = get_node(_drop_zone_path)

var _drag_data: Variant


func _ready() -> void:
	_drag_data = null
	_drag_zone.dragged.connect(_on_dragged)


func _unhandled_input(event: InputEvent) -> void:
	if _drag_data == null:
		return
	
	if event is InputEventScreenDrag:
		pass
	elif event is InputEventScreenTouch and not event.is_pressed():
		if _drop_zone.can_drop(event.position, _drag_data):
			_drop_zone.drop(event.position, _drag_data)
			_drag_zone.dropped(_drag_data)
		else:
			_drag_zone.drag_canceled(_drag_data)
		_drag_data = null


func _on_dragged(data: Variant) -> void:
	if _drag_data == null:
		_drag_data = data
		_drag_zone.drag_started(_drag_data)

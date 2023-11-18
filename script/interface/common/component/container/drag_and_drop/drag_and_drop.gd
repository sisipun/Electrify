class_name DragAndDropp
extends Node


enum State {
	DEFAULT,
	DRAGGED
}


@export var _drag_and_drop_zone_paths: Array[NodePath]

@onready var _drag_and_drop_zones: Array = _drag_and_drop_zone_paths.map(func(it) -> Node: return get_node(it))

var _drag_data: Variant
var _drag_zone: Node
var _state: State


func _ready() -> void:
	cancel()
	for zone in _drag_and_drop_zones:
		if zone.has_signal("dragged"):
			zone.dragged.connect(Callable(_on_drag_started).bind(zone))


func _unhandled_input(event: InputEvent) -> void:
	if _state == State.DEFAULT:
		return
	
	if event is InputEventScreenDrag:
		_on_dragged(event.position, _drag_data, _drag_zone)
	elif event is InputEventScreenTouch and not event.is_pressed():
		_on_dropped(event.position, _drag_data, _drag_zone)


func cancel() -> void:
	_drag_data = null
	_drag_zone = null
	_state = State.DEFAULT


func _on_drag_started(drag_data: Variant, drag_zone: Node) -> void:
	if _state != State.DEFAULT:
		return
	
	_state = State.DRAGGED
	_drag_data = drag_data
	_drag_zone = drag_zone
	for zone in _drag_and_drop_zones:
		if zone.has_method("drag_started"):
			zone.drag_started(_drag_data, _drag_zone)


func _on_dragged(position: Vector2, drag_data: Variant, drag_zone: Node) -> void:
	for zone in _drag_and_drop_zones:
		if zone.has_method("dragged"):
			zone.dragged(position, drag_data, drag_zone)


func _on_dropped(position: Vector2, drag_data: Variant, drag_zone: Node) -> void:
	var dropped: bool = false
	for zone in _drag_and_drop_zones:
		if (
			zone.has_method("can_drop") 
			and zone.has_method("drop") 
			and zone.can_drop(position, drag_data, drag_zone)
		):
			zone.drop(position, drag_data, drag_zone)
			dropped = true
			break
	
	var method_to_call: String = "dropped" if dropped else "drag_canceled"
	for zone in _drag_and_drop_zones:
		if zone.has_method(method_to_call):
			zone.call(method_to_call, drag_data, drag_zone)
	
	cancel()

class_name StationDefinition
extends Panel


signal dragged


@export_node_path("NinePatchRect") var _body_node_path: NodePath
@export_node_path("Label") var _count_label_node_path: NodePath

@onready var _body: NinePatchRect = get_node(_body_node_path)
@onready var _count_label: Label = get_node(_count_label_node_path)

var _count:
	set(value):
		_count = value
		_count_label.text = str(value)
var _type: StationModel.Type


func init(type: StationModel.Type, image: Texture, count: int) -> void:
	_type = type
	_body.texture = image
	_count = count


func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		emit_signal("dragged")


func get_type() -> StationModel.Type:
	return _type


func drag_started() -> void:
	_count -= 1


func drag_canceled() -> void:
	_count += 1


func dropped() -> void:
	pass

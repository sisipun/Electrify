class_name StationDefinition
extends Panel


func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		print('drag')

extends "res://addons/CoolButtonsLibrary/scripts/ButtonController.gd"

export var new_view : String = "main"

func release_action() -> void:
	.release_action()
	if(new_view != ""):
		ViewManager.change_view(new_view)


extends Node2D

# Add your views in this dictionary
# All views MUST be stored in the Node2D 'app'
# Don't remove the 'main' view, modify it instead
onready var views : Dictionary = {
	"main": get_view("main"),
}
onready var last_view = views["main"]
	
func _ready() -> void:
	setup()

func setup() -> void:
	for view in views:
		views[view].visible = false
		views[view].position = Vector2(720, 0)
	views["main"].visible = true
	views["main"].position = Vector2(0, 0)
	
# Tween the old view out of borders and put new view in
# Will call the method unsetup() in the old view, and setup() in the new view
# Be sure to implement these methods to all your views if you don't use the view_template.tscn
func change_view(new_view) -> void:
	if(last_view != new_view):
		for view in views:
			views[view].visible = false
		last_view.unsetup()
		last_view.visible = true
		new_view.setup()
		new_view.visible = true
		var tween : Tween = Tween.new()
		var tween_instance = add_child(tween)
		tween.interpolate_property(last_view, "position", last_view.position, Vector2(720, 0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
		tween.interpolate_property(new_view, "position", Vector2(-720, 0), Vector2(0, 0), 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
		last_view = new_view
		yield(get_tree().create_timer(1), "timeout")		
		tween.queue_free()

# Return the view (given by name) stored in Node2D 'app'
func get_view(view_name : String) -> Node:
	var view : Node = get_parent().get_node(str("app/", view_name))
	return view

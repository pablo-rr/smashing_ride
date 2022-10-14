tool
extends EditorPlugin

var editting : bool = false
var path_editing : Spatial = null
var current_button_index : int = -69420
var clicks : int = 0

var paths : Spatial

var control : Control = Control.new()
var btn_load : Button = Button.new()
var lbl_helper : Label = Label.new()
var btn_new_path : Button = Button.new()
var scrl_paths : ScrollContainer = ScrollContainer.new()
var ctn_paths : VBoxContainer = VBoxContainer.new()
var color_picker : ColorPicker = ColorPicker.new()

func _input(event: InputEvent) -> void:
	if(event is InputEventMouseButton and event.button_index == BUTTON_LEFT and editting):
		clicks += 1
		if(clicks % 2 == 0):
			var space_state : PhysicsDirectSpaceState = get_tree().get_edited_scene_root().get_world().direct_space_state
			var ray_origin = get_editor_camera(0).project_ray_origin(event.position)
#			var ray_origin = get_editor_camera(0).transform.origin
			var ray_end = ray_origin + get_editor_camera(0).project_ray_normal(event.position) * 2000
#			var ray_end = get_editor_camera(0).project_ray_normal(event.position) * 2000
			var intersection : Dictionary = space_state.intersect_ray(ray_origin, ray_end)
			
			if(not intersection.empty()):
				var path_point : PackedScene = load("res://scenes/paths/pathPoint.tscn")
				var path_point_inst : Spatial = path_point.instance()
				path_point_inst.transform.origin = intersection.position - Vector3(8.615, 0, 2.19)
				paths.get_node(path_editing.name).add_child(path_point_inst)
				path_point_inst.owner = get_tree().get_edited_scene_root()
			else:
				print("No collision í ½í¸£")
	elif(event is InputEventKey and event.is_action_pressed("ui_cancel")):
		for i in ctn_paths.get_child_count():
			ctn_paths.get_child(i).get_node("Button").text = "Edit"
		
		editting = false

			
func _enter_tree() -> void:
	control.rect_min_size.y = 300
	btn_load.text = "Load"
	btn_load.connect("button_down", self, "load_plugin")
	
	add_control_to_bottom_panel(control, "Path Maker")
	
	control.add_child(btn_load)

func _exit_tree() -> void:
	control.queue_free()
	
func setup() -> void:
	btn_new_path.text = "New path"
	btn_new_path.connect("button_down", self, "create_path")
	scrl_paths.rect_position.y = 30
	scrl_paths.rect_min_size = Vector2(200, 280)
	lbl_helper.text = "To use: Camera in Orthogonal Y, Camera zoom at 9.2u"
	lbl_helper.rect_position.x = 100
	color_picker.edit_alpha = false
	color_picker.rect_size = Vector2(308, 412)
	color_picker.rect_scale = Vector2(0.5, 0.5)
	color_picker.rect_position = Vector2(250, 30)
	
	control.add_child(btn_new_path)
	control.add_child(scrl_paths)
	control.add_child(lbl_helper)
	control.add_child(color_picker)
	scrl_paths.add_child(ctn_paths)

	setup_paths()
	
func load_plugin() -> void:
	if(is_correct_scene(get_tree().get_edited_scene_root().name)):
		setup()
	
func is_correct_scene(scene_name : String) -> bool:
	if(scene_name == "game"):
		return true
	else:
		return false
	
func setup_paths() -> void:
	var scene : Spatial = get_tree().get_edited_scene_root()
	new_path_ui()
	
func new_path_ui() -> void:
	paths = get_tree().get_edited_scene_root().get_node("paths")

	for i in ctn_paths.get_child_count():
		ctn_paths.get_child(i).queue_free()

	for i in paths.get_child_count():
		var new_path : VBoxContainer = VBoxContainer.new()
		ctn_paths.add_child(new_path)
		
		var new_path_name : Label = Label.new()
		new_path_name.text = paths.get_child(i).name
		new_path.add_child(new_path_name)
		
		var new_path_edit : Button = Button.new()
		new_path_edit.text = "Edit"
		new_path.add_child(new_path_edit)
		new_path_edit.connect("button_down", self, "edit_path", [paths.get_child(i).name, i])
	
func create_path() -> void:
	if(is_correct_scene(get_tree().get_edited_scene_root().name)):
		var paths : Spatial = get_tree().get_edited_scene_root().get_node("paths")
		var scene : Spatial = get_tree().get_edited_scene_root()
		var new_path : Spatial = load("res://scenes/paths/pathParent.tscn").instance()
		new_path.name = str("path", paths.get_child_count() + 1)
		paths.add_child(new_path)
		new_path.set_owner(get_tree().get_edited_scene_root())
		new_path_ui()
		
func edit_path(path_name : String, button_idx : int) -> void:
	if(button_idx != current_button_index):
		current_button_index = button_idx
		for i in ctn_paths.get_child_count():
			ctn_paths.get_child(i).get_node("Button").text = "Edit"
			
		editting = true
		ctn_paths.get_child(button_idx).get_node("Button").text = "Editting"
		path_editing = paths.get_node(path_name)
	else:
		editting = false
		for i in ctn_paths.get_child_count():
			ctn_paths.get_child(i).get_node("Button").text = "Edit"
			
		
func get_editor_camera(cam_index : int) -> Spatial:
	var e = get_editor_interface().get_editor_viewport()
	var cam = e.get_child(1).get_child(1).get_child(0).get_child(0).get_child(cam_index).get_child(0).get_child(0).get_camera()
	return cam

tool
extends EditorScript

func _run() -> void:
	var paths : Spatial = get_scene().get_node("path")
	var scene : Spatial = get_scene()
	var roads : GridMap = get_scene().get_node("roads")
	var roads_data : Array = roads.get_meshes()
	var path_point : PackedScene = load("res://scenes/pathPoint.tscn")
	
	var road_origin : Vector3
	
	for road in roads_data:
		if(road is Transform):
			road_origin = road.origin
			print(road.orientation)
#		else:
#			var path_point_inst : Spatial = path_point.instance()
#			print(path_point_inst.owner)
#			path_point_inst.transform.origin = road_origin
##			path_point_inst.set_owner(null)
#			paths.add_child(path_point_inst)
#			path_point_inst.owner = paths.get_tree().get_edited_scene_root()

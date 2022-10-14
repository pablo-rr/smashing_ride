tool
extends EditorScript

func _run() -> void:
	var scene : Spatial = get_scene()
	print(scene.get_node("paths/path1/pathPoint").transform.origin)
	print(scene.get_node("paths/path1/pathPoint2").transform.origin)
	print(
		(scene.get_node("paths/path1/pathPoint").transform.origin
		-
		scene.get_node("paths/path1/pathPoint2").transform.origin).normalized()
	)

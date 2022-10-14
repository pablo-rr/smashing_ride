extends GridMap

onready var return_cells = get_meshes()
onready var hidden : Array = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#	var cells : Array = get_meshes()
#	print(cells[0][3])
#	for cell in cells.size():
#		if(cell % 2 == 0):
#			print("ARRAY")
	
	
	
	
	
	
	
	var cells : Array = get_used_cells()
	for cell in cells:
		var cell_pos : Vector3 = map_to_world(cell.x, cell.y, cell.z)
		var cam_pos : Vector3 = get_parent().get_node("Camera").transform.origin
		var x : float = (cell_pos.x - cam_pos.x) * (cell_pos.x - cam_pos.x)
#		var y : float = (cell_pos.y - cam_pos.y) * (cell_pos.y - cam_pos.y)
		var z : float = (cell_pos.z - cam_pos.z) * (cell_pos.z - cam_pos.z)
#		var dist : float = sqrt(x + z)
		var dist : float = cam_pos.x - cell_pos.x

		if(dist > -1.5):
			var pos : Array = [cell.x, cell.y, cell.z]
			var data : Array = []
			data.append(pos)
			data.append(get_cell_item(cell.x, cell.y, cell.z))
			if(!data in hidden):
				hidden.append(data)
#			print(hidden)
			set_cell_item(cell.x, cell.y, cell.z, 0)
		else:
			var pos : Array = [cell.x, cell.y, cell.z]
			for h in hidden.size():
				print(h)
#				if(h[0] == pos):
##					set_cell_item(cell.x, cell.y, cell.z, hidden[h][1])
#					hidden.remove(h)

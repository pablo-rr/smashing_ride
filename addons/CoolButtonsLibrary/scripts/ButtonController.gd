extends TextureButton

export var button_icon : Texture = null setget set_button_icon
export var button_description : String = "desc" setget set_button_description

onready var press_offset : int = rect_size.y/20

func _ready() -> void:
	connect("button_down", self, "press_action")
	connect("button_up", self, "release_action")
	
func play_sfx() -> void:
	randomize()
	$pressSfx.pitch_scale = rand_range(0.9, 1.1)
	$pressSfx.play()
	
func get_game() -> Node:
	if(get_owner().get_owner() != null and get_owner().get_owner().name == "game"):
		return get_owner().get_owner()
	elif(get_owner().get_parent() != null and get_owner().get_parent().name == "game"):
		return get_owner().get_parent()
	else:
		push_warning(str("Node2D 'game' was not located as parent/owner of ", get_owner().get_class(), " '", get_owner().name, "' (", get_owner(), ")"))
		return Node.new()

func press_action() -> void:
	$content.rect_position.y += press_offset
	play_sfx()
	
func release_action() -> void:
	$content.rect_position.y -= press_offset
		
func set_button_icon(icon : Texture) -> void:
	button_icon = icon
	$content/icon.texture = icon
	
func set_button_description(desc : String) -> void:
	if(get_node_or_null("content/buttonDesc") != null):
		button_description = desc
		$content/buttonDesc.text = desc

tool
extends TextureButton

signal button_released
signal button_pressed

export var button_icon : Texture = null setget set_button_icon
export var button_description : String = "desc" setget set_button_description
export(String, "Self modulation", "Generic", "Success", "Error", "Warn", "White", "Lavender", "Pink", "Purple", "Orange") var button_color : String = "Generic" setget setup_color

onready var press_offset : int = rect_size.y/20

func _ready() -> void:
	setup_color(button_color)
	connect("button_down", self, "press_action")
	connect("button_up", self, "release_action")

func setup_color(color_name : String) -> void:
	button_color = color_name
	var new_color : Color
	if(color_name == "Generic"):
		new_color = PremadeColors.COLOR_GENERIC
	elif(color_name == "Success"):
		new_color = PremadeColors.COLOR_SUCCESS
	elif(color_name == "Error"):
		new_color = PremadeColors.COLOR_ERROR
	elif(color_name == "Warn"):
		new_color = PremadeColors.COLOR_WARN
	elif(color_name == "Lavender"):
		new_color = PremadeColors.COLOR_LAVENDER
	elif(color_name == "Pink"):
		new_color = PremadeColors.COLOR_PINK
	elif(color_name == "Purple"):
		new_color = PremadeColors.COLOR_PURPLE
	elif(color_name == "White"):
		new_color = PremadeColors.COLOR_WHITE
	elif(color_name == "Orange"):
		new_color = PremadeColors.COLOR_ORANGE
	else:
		new_color = PremadeColors.COLOR_GENERIC
	
	if(color_name != "Self modulation"):
		self_modulate = Color8(new_color.r, new_color.g, new_color.b)
	
func play_sfx() -> void:
	randomize()
	$pressSfx.pitch_scale = rand_range(0.95, 1.05)
	$pressSfx.play()

func press_action() -> void:
	emit_signal("button_pressed")
	$content.rect_position.y += press_offset
	play_sfx()
	
func release_action() -> void:
	emit_signal("button_released")
	$content.rect_position.y -= press_offset
		
func set_button_icon(icon : Texture) -> void:
	button_icon = icon
	$content/icon.texture = icon
	
func set_button_description(desc : String) -> void:
	if(get_node_or_null("content/buttonDesc") != null):
		button_description = desc
		$content/buttonDesc.text = desc

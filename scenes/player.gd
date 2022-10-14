extends KinematicBody

onready var virtual_joystick : VirtualJoystick = get_parent().get_node("UI/virtual_joystick")
export var max_speed : float = 3
export var accel : float = 0.07

onready var direction : Vector2 = Vector2.ZERO
onready var running : bool = false
onready var turbo_time : float = 0.0
onready var speed : float = max_speed
onready var jump_point : Spatial = null
onready var rot_frames : Array = []

func _ready() -> void:
	for i in range(0, 5):
		rot_frames.append(0)
		
	print(rot_frames.size())

func _physics_process(delta : float) -> void:
	move(delta)
	turbo(delta)
	engine_sounds()
	look_at_jump()
#	drift()
	$hitPart.rotation_degrees.y = -rotation_degrees.y
	
func drift() -> void:
	var total_drift : float = 0.0
	rot_frames.insert(0, rotation_degrees.y)
	rot_frames.remove(rot_frames.size())
	
	for i in rot_frames.size():
		total_drift -= rot_frames[i]
	
	print(total_drift / rot_frames.size())
	
	if(abs(total_drift / rot_frames.size()) > 5):
		print(">5")
	
func engine_sounds() -> void:
	if(running):
		$engine.pitch_scale = lerp($engine.pitch_scale, 2.3, 0.05)
	else:
		$engine.pitch_scale = lerp($engine.pitch_scale, 0.7, 0.075)
	
	
func move(delta : float) -> void:
	var dir_angle : float = rad2deg(virtual_joystick.get_output().angle()) - 45
	var real_dir : Vector2 = -Vector2.RIGHT.rotated(deg2rad(dir_angle))
	speed = lerp(speed, max_speed, 0.037)
	if(virtual_joystick and virtual_joystick.is_pressed()):
		rotation_degrees.y = -dir_angle + 270
#		get_parent().get_node("UI/Arrow/Viewport/space/MeshInstance").rotation_degrees.y = -dir_angle + 270
		if(!running):
			$start.play(0.0)
			running = true
			$lSmoke.emitting = true
			$rSmoke.emitting = true
			
	else:
#		$engine.pitch_scale = lerp($engine.pitch_scale, 1.0, 0.05)
#		$engine.stop()
		$start.stop()
		$lSmoke.emitting = false
		$rSmoke.emitting = false
		running = false
		real_dir = Vector2.ZERO
		
	direction.x = lerp(direction.x, real_dir.x, accel)
	direction.y = lerp(direction.y, real_dir.y, accel)
	move_and_slide(Vector3(direction.x, 0, direction.y) * speed)
	
func look_at_jump() -> void:
	if(jump_point != null):
		print("looking")
		look_at(jump_point.global_transform.origin, Vector3(1, 0, 0))
	
func turbo(delta) -> void:
	if(turbo_time > 0.0):
		turbo_time -= delta
		max_speed = 6
		get_parent().get_node("Camera").fov = lerp(get_parent().get_node("Camera").fov, 120, 0.08)
		$AnimationPlayer.play("turbo")
	else:
		max_speed = 3
		get_parent().get_node("Camera").fov = lerp(get_parent().get_node("Camera").fov, 90, 0.08)

func _on_npcHit_body_entered(body: Node) -> void:
	direction *= -1
	speed = max_speed
	$hitPart.emitting = false
	$hitPart.emitting = true
	$hitSnd.stop()
	$hitSnd.play(0.0)
	if("npc" in body.name):
		body.hit(transform.origin)
		speed = 0

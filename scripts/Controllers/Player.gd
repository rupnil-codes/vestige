extends CharacterBody3D

@onready var vestige_scene_var: Node3D = %VestigeSceneVar
@onready var watch_tower: Node3D = $"../World/WatchTower3D"
@onready var bunker: Node3D = $"../World/Bunker3D"
@onready var player_animation_player: AnimationPlayer = %PlayerAnimationPlayer

@onready var player_entered_tower: bool = watch_tower._player_entered_tower
@onready var player_entered_bunker_stairs: bool = bunker._player_entered_bunker_stairs
@onready var player_on_stairs: bool = player_entered_tower or player_entered_bunker_stairs

var captured: bool = true

@export var look_sensitivity: float = 0.005
@export var jump_velocity: float = 6.0
@export var auto_bhop: bool = true

const HEADBOB_MOVE_AMOUNT: float = 0.1
const HEADBOB_FREQUENCY: float = 2.0
var headbob_time: float = 0.0

# ground
@export var walk_speed: float = 4.25
@export var sprint_speed: float = 5.25
@export var ground_accel: float = 14.0
@export var ground_decel: float = 10.0
@export var ground_friction: float = 4.5
var is_walking: bool = false

# air
var is_jumping: bool = false
# var _jump_stop_countdown: int = 20
@export var air_cap: float = 0.85
@export var air_accel: float = 800.0
@export var air_move_speed: float = 500.0

var wish_dir := Vector3.ZERO
var cam_aligned_wish_dir := Vector3.ZERO

const CROUCH_TRANSLATE: float = 0.7
const CROUCH_JUMP_ADD: float = CROUCH_TRANSLATE * 0.9
var is_crouched: bool = false

var noclip_speed_mult:float = 3.0
var noclip: bool = false

const MAX_STEP_HEIGHT: float = 0.8
@onready var separation_ray: CollisionShape3D = %SeparationRay3D
@onready var stairs_below_raycast: RayCast3D = %StairsBelowRayCast3D
var _snapped_to_stairs_last_frame: bool = false
var did_snap: bool = false
var _last_frame_was_on_floor := -INF

@export var smooth_step_speed: float = 10.0
var smooth_step_speed_mult: float = 1.0
var _visual_offset_y: float = 0.0

@onready var interaction_ray_cast: RayCast3D = %InteractionRayCast3D
@onready var interaction_text: Label = %InteractionText
var _is_ending_bench_interacting: bool = false

var is_walking_cutscene: bool = false
var _cant_jump_switch: bool = false

func get_move_speed() -> float:
	if is_crouched:
		return walk_speed * 0.8
	return sprint_speed if Input.is_action_pressed("sprint") else walk_speed

func _ready():
	separation_ray.disabled = true
	for child in %WorldModel.find_children("*", "VisualInstance3D"):
		child.set_layer_mask_value(1, false)
		child.set_layer_mask_value(2, true)

func _unhandled_input(event: InputEvent) -> void:
	if captured:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event is InputEventMouseButton:
		captured = true
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		captured = false
	if vestige_scene_var.cutscene:
		return

	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * look_sensitivity)
			
			%Head.rotate_x(-event.relative.y * look_sensitivity)
			%Head.rotation.x = clamp(
				%Head.rotation.x,
				deg_to_rad(-80),
				deg_to_rad(80)
			)

	if event.is_action_pressed("interact") and _is_ending_bench_interacting:
		%VestigeAnimationPlayer.play("fade_to_black")
		await %VestigeAnimationPlayer.animation_finished
		vestige_scene_var.cutscene = true
		%VestigeAnimationPlayer.play("ending_camera_move_invisible")
		await %VestigeAnimationPlayer.animation_finished
		%VestigeAnimationPlayer.play_backwards("fade_to_black")
		await %VestigeAnimationPlayer.animation_finished
		is_walking_cutscene = true
		%VestigeAnimationPlayer.play("ending_camera_cut_scene")
		await %VestigeAnimationPlayer.animation_finished
		%VestigeAnimationPlayer.play("any_key_continue_animation")
		await %VestigeAnimationPlayer.animation_finished
		is_walking_cutscene = false
		vestige_scene_var.cutscene = false

	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			noclip_speed_mult = min(100.0, noclip_speed_mult * 1.1)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			noclip_speed_mult = max(0.1, noclip_speed_mult * 0.9)


func _headbob_effect(delta: float):
	headbob_time += delta * self.velocity.length()
	
	%Camera3D.position = Vector3(
			cos(headbob_time * HEADBOB_FREQUENCY * 0.5) * HEADBOB_MOVE_AMOUNT,
			sin(headbob_time * HEADBOB_FREQUENCY) * HEADBOB_MOVE_AMOUNT,
			0.0
	)

func _process(delta: float) -> void:
	player_entered_tower = watch_tower._player_entered_tower
	player_entered_bunker_stairs = bunker._player_entered_bunker_stairs

	player_on_stairs = player_entered_tower or player_entered_bunker_stairs

	if player_on_stairs and not is_jumping:
		separation_ray.disabled = false
		_visual_offset_y = lerp(_visual_offset_y, 0.0, smooth_step_speed * delta * smooth_step_speed_mult)
		%Camera3D.position.y = _visual_offset_y
	else:
		separation_ray.disabled = true

	if _is_ending_bench_interacting and not vestige_scene_var.cutscene:
		interaction_text.text = "Press  [E]  to interact"
	else:
		interaction_text.text = ""


func _snap_down_to_stairs_check() -> void:
	did_snap = false
	smooth_step_speed_mult = 1.0
	var floor_below: bool = stairs_below_raycast.is_colliding() and not is_surface_too_steep(%StairsBelowRayCast3D.get_collision_normal())
	var was_on_floor_last_frame := Engine.get_physics_frames() - _last_frame_was_on_floor == 1
	if not is_jumping and player_on_stairs and not is_on_floor() and velocity.y <= 0 and (was_on_floor_last_frame or _snapped_to_stairs_last_frame) and floor_below:
		var body_test_result: PhysicsTestMotionResult3D = PhysicsTestMotionResult3D.new()
		if _run_body_test_motion(self.global_transform, Vector3(0, -MAX_STEP_HEIGHT, 0), body_test_result):
			var translate_y: float = body_test_result.get_travel().y
			self.position.y += translate_y
			apply_floor_snap()
			did_snap = true
			smooth_step_speed_mult = 0.3


		_snapped_to_stairs_last_frame = did_snap

@onready var _original_capsule_height: float = $CollisionShape3D.shape.height
func _handle_crouch(delta: float) -> void:
	if Input.is_action_pressed("crouch"):
		is_crouched = true
	elif is_crouched and not self.test_move(self.transform, Vector3(0,CROUCH_TRANSLATE,0)):
		is_crouched = false

	# %Head.position = Vector3(0, (-CROUCH_TRANSLATE if is_crouched else 0),0)
	%Head.position.y = move_toward(%Head.position.y, -CROUCH_TRANSLATE if is_crouched else 0, 5.0 * delta)
	$CollisionShape3D.shape.height = _original_capsule_height - CROUCH_TRANSLATE if is_crouched else _original_capsule_height
	$CollisionShape3D.position.y = $CollisionShape3D.shape.height / 2

func _handle_noclip(delta: float) -> bool:
	if Input.is_action_just_pressed("_noclip") and OS.has_feature("debug"):
		if noclip:
			noclip = false
		else:
			noclip = true
		noclip_speed_mult = 3.0

	$CollisionShape3D.disabled = noclip

	if not noclip:
		return false

	var speed: float = get_move_speed() * noclip_speed_mult
	if Input.is_action_pressed("sprint"):
		speed *= 3.0

	self.velocity = cam_aligned_wish_dir * speed
	global_position += self.velocity * delta

	return true

func clip_velocity(normal: Vector3, overbounce: float, delta: float) -> void:
	var backoff: float = self.velocity.dot(normal) * overbounce

	if backoff >= 0: return

	var change: Vector3 = normal * backoff
	self.velocity -= change

	var adjust: float = self.velocity.dot(normal)
	if adjust < 0.0:
		self.velocity -= normal * adjust

func is_surface_too_steep(normal: Vector3) -> bool:
	return normal.angle_to(Vector3.UP) > self.floor_max_angle

func _run_body_test_motion(from: Transform3D, motion: Vector3, result = null) -> bool:
	if not result:
		result = PhysicsTestMotionResult3D.new()
	var params: PhysicsTestMotionParameters3D = PhysicsTestMotionParameters3D.new()
	params.from = from
	params.motion = motion
	return PhysicsServer3D.body_test_motion(self.get_rid(), params, result)

func _handle_air_physics(delta: float) -> void:
	self.velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta

	var cur_speed_in_wish_dir: float = self.velocity.dot(wish_dir)
	var capped_speed = min((air_move_speed * wish_dir).length(), air_cap)
	var add_speed_till_cap = capped_speed - cur_speed_in_wish_dir

	if add_speed_till_cap > 0:
		var accel_speed: float = air_accel * air_move_speed * delta
		accel_speed = min(accel_speed, add_speed_till_cap)
		self.velocity += accel_speed * wish_dir

	if is_on_wall():
		if is_surface_too_steep(get_wall_normal()):
			self.motion_mode = CharacterBody3D.MOTION_MODE_FLOATING
		else:
			self.motion_mode = CharacterBody3D.MOTION_MODE_GROUNDED
		clip_velocity(get_wall_normal(), 1, delta)

func _handle_ground_physics(delta: float) -> void:
	var cur_speed_in_wish_dir: float = self.velocity.dot(wish_dir)
	var add_speed_till_cap: float = get_move_speed() - cur_speed_in_wish_dir
	if add_speed_till_cap > 0:
		var accel_speed: float = ground_accel * get_move_speed() * delta
		accel_speed = min(accel_speed, add_speed_till_cap)
		self.velocity += accel_speed * wish_dir

	var control = max(self.velocity.length(), ground_decel)
	var drop = control * ground_friction * delta
	var new_speed = max(self.velocity.length() - drop, 0.0)
	if self.velocity.length() > 0:
		new_speed /= self.velocity.length()
	self.velocity *= new_speed

	_headbob_effect(delta)

func _physics_process(delta: float) -> void:

	if vestige_scene_var.cutscene:
		return
	
	if not is_jumping and wish_dir.length() > 0.1:
		if player_on_stairs:
			%WalkStairsAnimationPlayer.play("walk_stairs", -1, get_move_speed()/4.25)
		else:
			%WalkStairsAnimationPlayer.stop()
		
		if is_on_floor() and not player_on_stairs:
			is_walking = true
			%WalkAnimationPlayer.play("walk", -1, get_move_speed()/4.25)
		else:
			is_walking = false
			%WalkAnimationPlayer.stop()
	else:
		is_walking = false
		%WalkAnimationPlayer.stop()
		%WalkStairsAnimationPlayer.stop()
	

	if interaction_ray_cast.is_colliding():
		var target: Object = interaction_ray_cast.get_collider()
		var target_name: String = target.name

		if target_name == "EndingBenchArea" or target_name == "EndingBenchBody3D":
			_is_ending_bench_interacting = true
		else:
			_is_ending_bench_interacting = false
	else:
		_is_ending_bench_interacting = false

	if is_on_floor():
		_last_frame_was_on_floor = Engine.get_physics_frames()

	if wish_dir.length() >= 0.1:
		var target_angle: float = atan2(-wish_dir.x, -wish_dir.z)
		separation_ray.rotation.y = target_angle

	var input_dir := Input.get_vector("left", "right", "up", "down").normalized()

	wish_dir = self.global_transform.basis * Vector3(-input_dir.x, 0., -input_dir.y)
	cam_aligned_wish_dir = %Camera3D.global_transform.basis * Vector3(input_dir.x, 0., input_dir.y)

	_handle_crouch(delta)

	if not _handle_noclip(delta):
		if is_on_floor():
			is_jumping = false
			if Input.is_action_just_pressed("jump") or (auto_bhop and Input.is_action_pressed("jump")):
				if player_on_stairs:
					if not _cant_jump_switch and not %DialogueText.writing:
						%DialogueText.typewrite("The stair creaks. You do not have the courage to jump.", true)
						_cant_jump_switch = true
					else:
						%DialogueText.typewrite("You do not dare to jump...", true, 0.5)
				else:
					is_jumping = true
					self.velocity.y = jump_velocity
			_handle_ground_physics(delta)
		else:
			_handle_air_physics(delta)

		var pos_before_physics: Vector3 = global_position

		move_and_slide()
		_snap_down_to_stairs_check()

		if player_on_stairs:
			_visual_offset_y += (pos_before_physics.y - global_position.y)

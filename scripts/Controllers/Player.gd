extends CharacterBody3D

var captured: bool = true
@onready var prologue_scene: Node3D = $"../../.."

@export var look_sensitivity: float = 0.005
@export var jump_velocity: float = 6.0
@export var auto_bhop: bool = true

const HEADBOB_MOVE_AMOUNT: float = 0.1
const HEADBOB_FREQUENCY: float = 2.0
var headbob_time: float = 0.0

# ground
@export var walk_speed: float = 4.5
@export var sprint_speed: float = 8.0
@export var ground_accel: float = 14.0
@export var ground_decel: float = 10.0
@export var ground_friction: float = 4.5

# air
@export var air_cap: float = 0.85
@export var air_accel: float = 800.0
@export var air_move_speed: float = 500.0

var wish_dir := Vector3.ZERO
var cam_aligned_wish_dir := Vector3.ZERO

var noclip_speed_mult:float = 3.0
var noclip: bool = false

const MAX_STEP_HEIGHT: float = 0.6
var _snapped_to_stairs_last_frame: bool = false
var _last_frame_was_on_floor := -INF

func get_move_speed() -> float:
	return sprint_speed if Input.is_action_pressed("sprint") else walk_speed

func _ready():
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
	if prologue_scene.waking_up:
		return

	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * look_sensitivity)
			%Camera3D.rotate_x(-event.relative.y * look_sensitivity)
			%Camera3D.rotation.x = clamp(
				%Camera3D.rotation.x,
				deg_to_rad(-90),
				deg_to_rad(90)
			)
			
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			noclip_speed_mult = min(100.0, noclip_speed_mult * 1.1)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			noclip_speed_mult = max(0.1, noclip_speed_mult * 0.9)
	
func _headbob_effect(delta: float):
	headbob_time += delta * self.velocity.length()
	%Camera3D.transform.origin = Vector3(
		cos(headbob_time * HEADBOB_FREQUENCY * 0.5) * HEADBOB_MOVE_AMOUNT,
		sin(headbob_time * HEADBOB_FREQUENCY) * HEADBOB_MOVE_AMOUNT,
		0
	)

func _process(delta: float) -> void:
	pass

func _snap_up_stairs_check(delta: float) -> bool:
	if not is_on_floor() and not _snapped_to_stairs_last_frame:
		return false
	var expected_move_motion: Vector3 = self.velocity * Vector3(0,1,0) * delta
	var step_pos_with_clearance: Transform3D = self.global_transform.translated(expected_move_motion + Vector3(0, 2 * MAX_STEP_HEIGHT, 0))
	
	var down_check_result: PhysicsTestMotionResult3D = PhysicsTestMotionResult3D.new()
	if (_run_body_test_motion(step_pos_with_clearance, Vector3(0,-MAX_STEP_HEIGHT*2,0), down_check_result)
	and (down_check_result.get_collider().is_class("StaticBody3D") or down_check_result.get_collider().is_class("CSGShape3D"))):
		var step_height: float = ((step_pos_with_clearance.origin + down_check_result.get_travel()) - self.global_position).y
		
		if step_height > MAX_STEP_HEIGHT or step_height <= 0.01 or (down_check_result.get_collision_point() - self.global_position).y > MAX_STEP_HEIGHT:
			return false
		%StairsAheadRayCast3D.global_position = down_check_result.get_collision_point() + Vector3(0,MAX_STEP_HEIGHT,0) + expected_move_motion.normalized() * 0.1
		%StairsAheadRayCast3D.force_raycast_update()
		if %StairsAheadRayCast3D.is_colliding() and not is_surface_too_steep(%StairsAheadRayCast3D.get_collision_normal()):
			self.global_position = step_pos_with_clearance.origin + down_check_result.get_travel()
			apply_floor_snap()
			_snapped_to_stairs_last_frame = true
			return true
	
	return false

func _snap_down_to_stairs_check() -> void:
	var did_snap: bool = false
	var floor_below: bool = %StairsBelowRayCast3D.is_colliding() and not is_surface_too_steep(%StairsBelowRayCast3D.get_collision_normal())
	var was_on_floor_last_frame := Engine.get_physics_frames() - _last_frame_was_on_floor == 1
	if not is_on_floor() and velocity.y <= 0 and (was_on_floor_last_frame or _snapped_to_stairs_last_frame) and floor_below:
		var body_test_result: PhysicsTestMotionResult3D = PhysicsTestMotionResult3D.new()
		if _run_body_test_motion(self.global_transform, Vector3(0, -MAX_STEP_HEIGHT, 0), body_test_result):
			var translate_y: float = body_test_result.get_travel().y
			self.position.y += translate_y
			apply_floor_snap()
			did_snap = true
		
		_snapped_to_stairs_last_frame = did_snap

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
	var params = PhysicsTestMotionParameters3D.new()
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
	if is_on_floor():
		_last_frame_was_on_floor = Engine.get_physics_frames()
	
	var input_dir := Input.get_vector("left", "right", "up", "down").normalized()
	
	wish_dir = self.global_transform.basis * Vector3(-input_dir.x, 0., -input_dir.y)
	cam_aligned_wish_dir = %Camera3D.global_transform.basis * Vector3(input_dir.x, 0., input_dir.y)
	
	if not _handle_noclip(delta):
		if is_on_floor() or _snapped_to_stairs_last_frame:
			if Input.is_action_just_pressed("jump") or (auto_bhop and Input.is_action_pressed("jump")):
				self.velocity.y = jump_velocity
			_handle_ground_physics(delta)
		else:
			_handle_air_physics(delta)
	
		if not _snap_up_stairs_check(delta):
			move_and_slide()
			_snap_down_to_stairs_check()

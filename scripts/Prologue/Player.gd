extends CharacterBody3D

const SPEED := 3.5
const JUMP_VELOCITY := 4.0

const MOUSE_SENS := 0.0045

const BOB_SPEED := 4.0
const BOB_HEIGHT := 0.16
const BOB_SIDE := 0.01
const BOB_ROLL := 0.01

@onready var neck: Node3D = $Neck
@onready var headbob: Node3D = $Neck/HeadBob
@onready var camera: Camera3D = $Neck/HeadBob/Camera3D
@onready var prologue_scene: Node3D = $"../../.."

var captured := true

var bob_time := 0.0
var landing_offset := 0.0
var was_on_floor := true

var headbob_origin: Vector3
var headbob_rot_origin: Vector3

func _ready() -> void:
	headbob_origin = headbob.position
	headbob_rot_origin = headbob.rotation

func _input(event: InputEvent) -> void:
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
			neck.rotate_y(-event.relative.x * MOUSE_SENS)
			camera.rotate_x(-event.relative.y * MOUSE_SENS)
			camera.rotation.x = clamp(
				camera.rotation.x,
				deg_to_rad(-60),
				deg_to_rad(90)
			)

func _physics_process(delta: float) -> void:

	if !is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") \
	and is_on_floor() \
	and !prologue_scene.waking_up:
		velocity.y = JUMP_VELOCITY

	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (
		neck.global_basis * Vector3(input_dir.x, 0, input_dir.y)
	).normalized()

	if !prologue_scene.waking_up:
		if direction != Vector3.ZERO:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0.0, SPEED)
			velocity.z = move_toward(velocity.z, 0.0, SPEED)

	if !was_on_floor and is_on_floor():
		landing_offset = -0.05

	was_on_floor = is_on_floor()
	landing_offset = lerp(landing_offset, 0.0, delta * 10.0)

	if input_dir.length() > 0.1 and is_on_floor():

		bob_time += delta * BOB_SPEED

		var side := sin(bob_time * 0.5)
		var up = abs(sin(bob_time))

		headbob.position.x = lerp(
			headbob.position.x,
			headbob_origin.x + side * BOB_SIDE,
			delta * 10.0
		)

		headbob.position.y = lerp(
			headbob.position.y,
			headbob_origin.y + up * BOB_HEIGHT + landing_offset,
			delta * 10.0
		)

		headbob.rotation.z = lerp(
			headbob.rotation.z,
			headbob_rot_origin.z + side * BOB_ROLL,
			delta * 10.0
		)

	else:

		bob_time = 0.0

		headbob.position.x = lerp(
			headbob.position.x,
			headbob_origin.x,
			delta * 10.0
		)

		headbob.position.y = lerp(
			headbob.position.y,
			headbob_origin.y + landing_offset,
			delta * 10.0
		)

		headbob.rotation.z = lerp(
			headbob.rotation.z,
			headbob_rot_origin.z,
			delta * 10.0
		)

	move_and_slide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	pass

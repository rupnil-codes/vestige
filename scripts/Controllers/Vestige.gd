extends Node3D

@onready var vestige_animation_player: AnimationPlayer = $VestigeAnimationPlayer
@onready var vestige_once_animation_player: AnimationPlayer = $VestigeOnceAnimationPlayer

@onready var dialogue_text: Label = %DialogueText
@onready var vestige_scene_var: Node3D = %VestigeSceneVar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_vestige_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player3D":
		vestige_animation()
		
func vestige_animation() -> void:
	vestige_scene_var.vestige_count += 1
	var count: int = vestige_scene_var.vestige_count
	

	vestige_animation_player.play("vestige_animation")
	play_once_animation()
	
	if count == 1:
		await dialogue_text.typewrite("Little and Innocent.", false, 1.0, 4.2)
	if count == 2:
		await dialogue_text.typewrite("Carefree and Joyous.", false, 1.0, 4.2)
	if count == 3:
		await dialogue_text.typewrite("Young and Adventurous.", false, 1.0, 4.2)
	if count == 4:
		await dialogue_text.typewrite("Loved and Loving.", false, 1.0, 4.2)
	if count == 5:
		await dialogue_text.typewrite("Focussed and Ambitious.", false, 1.0, 4.2)
	if count == 6:
		await dialogue_text.typewrite("Gone and Grieving.", false, 1.0, 4.2)
	if count == 7:
		await dialogue_text.typewrite("R E F L E C T I O N . . .", false, 1.0, 4.2)
	
	await vestige_once_animation_player.animation_finished

func play_once_animation() -> void:
	vestige_once_animation_player.play("play_once")
	await vestige_once_animation_player.animation_finished
	vestige_scene_var.entered_vestige_before_animation = true

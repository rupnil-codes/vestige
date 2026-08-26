extends Node3D

@onready var vestige_animation_player: AnimationPlayer = $VestigeAnimationPlayer
@onready var vestige_once_animation_player: AnimationPlayer = $VestigeOnceAnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_vestige_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player3D":
		vestige_animation_player.play("vestige_animation")
		vestige_once_animation_player.play("play_once")

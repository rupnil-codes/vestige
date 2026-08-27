extends Node3D

@onready var vestige_animation_player: AnimationPlayer = $VestigeAnimationPlayer
@onready var vestige_once_animation_player: AnimationPlayer = $VestigeOnceAnimationPlayer

@onready var dialogue_text: Label = %DialogueText

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_vestige_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player3D":
		dialogue_text.vestige_count += 1
		var count: int = dialogue_text.vestige_count
		
		if count == 1:
			dialogue_text.typewrite("Little and Innocent.", false, 1.0, 5.0)
		if count == 2:
			dialogue_text.typewrite("Carefree and Joyous.", false, 1.0, 5.0)
		if count == 3:
			dialogue_text.typewrite("Young and Adventurous.", false, 1.0, 5.0)
		if count == 4:
			dialogue_text.typewrite("Loved and Loving.", false, 1.0, 5.0)
		if count == 5:
			dialogue_text.typewrite("Focussed and Ambitious.", false, 1.0, 5.0)
		if count == 6:
			dialogue_text.typewrite("Gone and Grieving.", false, 1.0, 5.0)
		if count == 7:
			dialogue_text.typewrite("R E F L E C T I O N . . .", false, 1.0, 5.0)
		
		vestige_animation_player.play("vestige_animation")
		vestige_once_animation_player.play("play_once")
		
		

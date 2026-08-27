extends Node3D

@onready var weeping_silhouette_animation_player: AnimationPlayer = $WeepingSilhouetteAnimationPlayer
@export var _weeping_silhouette_animation_done: bool = false

@onready var dialogue_text: Label = %DialogueText

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player3D":
		weeping_silhouette_animation_player.play("vanish")

		await get_tree().create_timer(1).timeout
		await dialogue_text.typewrite("Look around you, something changed.", false, 0.8)
		await dialogue_text.typewrite("Goodbye closest friend.", false, 0.8)
		
		await weeping_silhouette_animation_player.animation_finished
		_weeping_silhouette_animation_done = true

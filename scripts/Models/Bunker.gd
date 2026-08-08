extends Node3D

@export var _player_entered_bunker_stairs: bool = false
@onready var weeping_silhouette_3d: Node3D = $"../WeepingSilhouette3D"
@onready var weeping_silhouette_animation_done: bool = weeping_silhouette_3d._weeping_silhouette_animation_done
@onready var bunker_animation_player: AnimationPlayer = $BunkerAnimationPlayer

@onready var vestige_animation_player: AnimationPlayer = $"../../../VestigeAnimationPlayer"
@onready var map_3d: Node3D = $"../WeepingSilhouette3D"

var is_closed: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weeping_silhouette_animation_done = weeping_silhouette_3d._weeping_silhouette_animation_done


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	weeping_silhouette_animation_done = weeping_silhouette_3d._weeping_silhouette_animation_done
	
	if weeping_silhouette_animation_done and is_closed:
		bunker_animation_player.play("open")
		is_closed = false


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player3D":
		_player_entered_bunker_stairs = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Player3D":
		_player_entered_bunker_stairs = false


func _on_door_close_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player3D":
		bunker_animation_player.play_backwards("open")
		vestige_animation_player.play("remove_main_map")

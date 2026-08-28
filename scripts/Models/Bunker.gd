extends Node3D

@export var _player_entered_bunker_stairs: bool = false
@onready var weeping_silhouette_3d: Node3D = $"../WeepingSilhouette3D"
@onready var bunker_animation_player: AnimationPlayer = %BunkerAnimationPlayer

@onready var vestige_animation_player: AnimationPlayer = $"../../../VestigeAnimationPlayer"
@onready var map_3d_1: Node3D = $"../Map3D"
@onready var map_3d_2: Node3D = $"../../World2/Map3D2"
@onready var dialogue_text: Label = %DialogueText

var is_closed: bool = true
var switch: bool = false
var hide_switch: bool = false
var jump_dialogue: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if weeping_silhouette_3d.weeping_silhouette_animation_done and is_closed and not switch:
		bunker_animation_player.play("open")
		is_closed = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_bunker") and OS.is_debug_build()	:
		bunker_animation_player.play("open")
		is_closed = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player3D":
		_player_entered_bunker_stairs = true

func _on_stairs_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Player3D":
		_player_entered_bunker_stairs = false


func _on_door_close_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player3D" and not is_closed:
		bunker_animation_player.play_backwards("open") # close
		vestige_animation_player.play("remove_main_map")
		map_3d_1.hide_main_map_meshes()
		is_closed = true
		switch = true


func _on_show_secondary_map_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player3D" and (switch or OS.is_debug_build()):
		vestige_animation_player.play("show_secondary_map")
		map_3d_2.show_secondary_map_meshes()
		hide_switch = true

func _on_jump_dialogue_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player3D" and not jump_dialogue:
		dialogue_text.typewrite(
				"Let go and fall free." + '\n' +
				"-A-C-C-E-P-T-A-N-C-E-"
		)
		jump_dialogue = true


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	if hide_switch:
		bunker_animation_player.play("hide_bunker")

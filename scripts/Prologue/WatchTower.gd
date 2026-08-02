extends Node3D

@export var _player_entered_tower: bool = false
var _last_safe: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_player_entered_tower = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player3D":
		_player_entered_tower = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Player3D":
		_player_entered_tower = false

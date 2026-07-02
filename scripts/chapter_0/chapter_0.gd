extends Node3D

var silhouettes_found = 0
const TOTAL_SILHOUETTES = 10

@onready var counter_label = $"Player3D/Neck/Camera3D/CanvasLayer/ColorRect/UserInterface/CounterLabel"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for silhouette in $Silhouettes.get_children():
		silhouette.silhouettes_found.connect(_on_silhouette_found)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_silhouette_found():
	silhouettes_found += 1
	counter_label.text = "%d/%d found" % [silhouettes_found, TOTAL_SILHOUETTES]
	
	

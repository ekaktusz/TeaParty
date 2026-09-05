extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start_button_pressed():
	# This click provides the user gesture browsers may require to start Web Audio.
	BgMusic.play()
	BgNoises.play()
	SceneTransition.change_scene_to_file("res://scenes/teashop_scene.tscn")
	pass # Replace with function body.

extends CanvasLayer

var is_transitioning := false

func change_scene_to_file(target: String) -> void:
	if is_transitioning:
		return
	is_transitioning = true
	$AnimationPlayer.play("dissolve")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("dissolve")
	await $AnimationPlayer.animation_finished
	is_transitioning = false

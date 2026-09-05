extends AudioStreamPlayer2D


func _ready() -> void:
	finished.connect(_restart)


func _restart() -> void:
	play()

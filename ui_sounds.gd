extends Node

const PAPER_MOVE := preload("res://sfx/paper_move.wav")
const GLASS_PING := preload("res://sfx/glass_ping_small.wav")
const WHOOSH := preload("res://sfx/whoosh_1.wav")

const UI_BUS := &"Master"

func _ready() -> void:
	for stream in [PAPER_MOVE, GLASS_PING, WHOOSH]:
		var player := AudioStreamPlayer.new()
		player.stream = stream
		player.bus = UI_BUS
		player.volume_db = -8.0
		add_child(player)

func play_paper(_opening: bool) -> void:
	_play(PAPER_MOVE, -5.0)

func play_unlock_reveal() -> void:
	_play(GLASS_PING, -7.0)

func play_ingredient_removed() -> void:
	_play(WHOOSH, -7.0)

func _play(stream: AudioStream, volume_db: float) -> void:
	for child in get_children():
		var player := child as AudioStreamPlayer
		if player != null and player.stream == stream:
			player.volume_db = volume_db
			player.play()
			return

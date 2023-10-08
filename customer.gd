extends Node2D

var fading: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	fade_in()
	pass # Replace with function body.

func readymeady() -> bool:
	return $Sprite2D.modulate == Color(1, 1, 1, 1)

func fade_in():
	self.fading = true
	$Sprite2D.modulate.a = 0
	var target_color = Color(1, 1, 1, 1)
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", target_color, 2)
	tween.tween_callback(self.fade_complete)

func fade_out():
	self.fading = true
	var target_color = Color(1, 1, 1, 0)
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", target_color, 2)
	tween.tween_callback(self.fade_complete)
	
func fade_complete():
	self.fading = false
	
func fade_completed():
	self.fading = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func load_from_data(customer: CustomerData):
	$Sprite2D.texture = load(customer.customerImage)
	pass

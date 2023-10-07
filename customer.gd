extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	fade_in()
	pass # Replace with function body.
	
func fade_in():
	$Sprite2D.modulate.a = 0
	var target_color = Color(1, 1, 1, 1)
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", target_color, 0.5)

func fade_out():
	var target_color = Color(1, 1, 1, 0)
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", target_color, 0.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func load_from_data(customer: CustomerData):
	$Sprite2D.texture = load(customer.customerImage)
	pass

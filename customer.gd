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
	var dbox = get_parent().get_node("DialogBox")
	$Sprite2D.modulate.a = 0
	dbox.modulate.a = 0
	
	var target_color = Color(1, 1, 1, 1)
	
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", target_color, 2)
	tween.tween_callback(self.fade_complete)
	
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property(dbox, "modulate", target_color, 2)
	if not SelectedIngredient.is_valid():
		tween2.tween_callback(dbox.start_print_effect)

func fade_out():
	var dbox = get_parent().get_node("DialogBox")
	self.fading = true
	var target_color = Color(1, 1, 1, 0)
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", target_color, 2)
	tween.tween_callback(self.fade_complete)
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property(dbox, "modulate", target_color, 2)
	tween2.tween_callback(dbox.clear)
	
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

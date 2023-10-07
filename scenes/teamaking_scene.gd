extends Node2D

var PropMenu = load("res://prop_menu.tscn")

var inventory = [
	""
]

var props = [
	PropData.new(
		"Bergamot",
		"res://images/props/bergamot.png",
		"res://images/cards/bergamot.png"
	),
	PropData.new(
		"Black Tea",
		"res://images/props/blacktea.png",
		"res://images/cards/black_tea.png"
	),
	PropData.new(
		"Chamomile",
		"res://images/props/chamomile.png",
		"res://images/cards/chamomile.png"
	),
	PropData.new(
		"Chili",
		"res://images/props/chili.png",
		"res://images/cards/chili.png"
	),
	PropData.new(
		"Chocolate",
		"res://images/props/chocolate.png",
		"res://images/cards/chocolate.png"
	),
	PropData.new(
		"Cinnamon",
		"res://images/props/cinnamon.png",
		"res://images/cards/cinnamon.png"
	),
	PropData.new(
		"Cloves",
		"res://images/props/cloves.png",
		"res://images/cards/cloves.png"
	)
]

# Called when the node enters the scene tree for the first time.
func _ready():
	for item in self.props:
		var prop = PropMenu.instantiate()
		prop.load(item)
		$GridContainer.add_child(prop)
		
	$SelectedProp1.disable()
	$SelectedProp1.notRealShit = true
	$SelectedProp2.disable()
	$SelectedProp2.notRealShit = true
	$SelectedProp3.disable()
	$SelectedProp3.notRealShit = true
	
	$MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel.text = CustomerDatabase.getCurrentCustomer().get_current_order_dialog()
	
	pass # Replace with function body.

func return_prop(propData: PropData):
	var allProps = $GridContainer.get_children()
	for prop in allProps:
		if prop.propData == propData:
			prop.enable()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Button.disabled = can_select()
	pass
	
func can_select():
	return $SelectedProp1.disabled or $SelectedProp2.disabled or $SelectedProp3.disabled

func select_prop(propData: PropData):
	if $SelectedProp1.disabled:
		$SelectedProp1.load(propData)
		$SelectedProp1.enable()
		return
	if $SelectedProp2.disabled:
		$SelectedProp2.load(propData)
		$SelectedProp2.enable()
		return
	if $SelectedProp3.disabled:
		$SelectedProp3.load(propData)
		$SelectedProp3.enable()
		return

func _on_selec_button_pressed():
	SceneTransition.change_scene_to_file("res://scenes/teashop_scene.tscn")
	SelectedIngredient.prop1 = $SelectedProp1.propData
	SelectedIngredient.prop2 = $SelectedProp2.propData
	SelectedIngredient.prop3 = $SelectedProp3.propData
	pass # Replace with function body.

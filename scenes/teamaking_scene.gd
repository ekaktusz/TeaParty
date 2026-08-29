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
	),
	PropData.new(
		"Dried Fruits",
		"res://images/props/dried_fruits.png",
		"res://images/cards/dried_fruits.png"
	),
	PropData.new(
		"Frogleg",
		"res://images/props/frogleg.png",
		"res://images/cards/frogleg.png"
	),
	PropData.new(
		"Ginger",
		"res://images/props/ginger.png",
		"res://images/cards/ginger.png"
	),
	PropData.new(
		"Green Tea",
		"res://images/props/greentea.png",
		"res://images/cards/green_tea.png"
	),
	PropData.new(
		"Herbal Tea",
		"res://images/props/herbaltea.png",
		"res://images/cards/herbal_tea.png"
	),
	PropData.new(
		"Honey",
		"res://images/props/honey.png",
		"res://images/cards/honey.png"
	),
	PropData.new(
		"Jasmine Petal",
		"res://images/props/jasmine.png",
		"res://images/cards/jasmine_petal.png"
	),
	PropData.new(
		"Lemon",
		"res://images/props/lemon.png",
		"res://images/cards/lemon.png"
	),
	PropData.new(
		"Lizard Liver",
		"res://images/props/lizard_liver.png",
		"res://images/cards/lizard_liver.png"
	),
	PropData.new(
		"Maple Syrup",
		"res://images/props/maple_syrup.png",
		"res://images/cards/maple_syrup.png"
	),
	PropData.new(
		"Mate Tea",
		"res://images/props/matetea.png",
		"res://images/cards/mate_tea.png"
	),
	PropData.new(
		"Milk",
		"res://images/props/milk.png",
		"res://images/cards/milk.png"
	),
	PropData.new(
		"Nutmeg",
		"res://images/props/nutmeg.png",
		"res://images/cards/nutmeg.png"
	),
	PropData.new(
		"Orange Peels",
		"res://images/props/orange_peel.png",
		"res://images/cards/orange_peels.png"
	),
	PropData.new(
		"Poppy Seed",
		"res://images/props/poppy_seed.png",
		"res://images/cards/poppy_seed.png"
	),
	PropData.new(
		"Roiboss",
		"res://images/props/roiboss.png",
		"res://images/cards/roiboss.png"
	),
	PropData.new(
		"Rose Petal",
		"res://images/props/rose.png",
		"res://images/cards/rose_petal.png"
	),
	PropData.new(
		"Unicorn Feather",
		"res://images/props/unicorn_feather.png",
		"res://images/cards/unicorn_feather.png"
	),
	PropData.new(
		"Vanilla",
		"res://images/props/vanilla.png",
		"res://images/cards/vanilla.png"
	),
	PropData.new(
		"Vinegar",
		"res://images/props/vinegar.png",
		"res://images/cards/vinegar.png"
	),
	PropData.new(
		"Water of Life",
		"res://images/props/water_of_life.png",
		"res://images/cards/water_of_life.png"
	),
	PropData.new(
		"Whisky",
		"res://images/props/whisky.png",
		"res://images/cards/whisky.png"
	),
	PropData.new(
		"White Tea",
		"res://images/props/whitetea.png",
		"res://images/cards/white_tea.png"
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
	
	$MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel.text = CustomerDatabase.get_current_customer().get_current_order_dialog()
	
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
	SteamSound.play()
	SceneTransition.change_scene_to_file("res://scenes/teashop_scene.tscn")
	SelectedIngredient.prop1 = $SelectedProp1.propData
	SelectedIngredient.prop2 = $SelectedProp2.propData
	SelectedIngredient.prop3 = $SelectedProp3.propData
	pass # Replace with function body.

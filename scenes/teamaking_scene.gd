extends Node2D

const PROP_MENU_SCENE := preload("res://prop_menu.tscn")

var _preview_card: IngredientCard

var inventory = [
	""
]

var props: Array[PropData] = [
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
	for ingredient_name in _unlock_database().get_unlocked_names_in_order():
		for item in self.props:
			if item.propName != ingredient_name:
				continue
			var prop := PROP_MENU_SCENE.instantiate() as IngredientCard
			prop.setup(item)
			_connect_card(prop)
			$GridContainer.add_child(prop)
			break
		
	for slot in _selected_slots():
		slot.is_selected_slot = true
		_connect_card(slot)

	_restore_selected_ingredients()
	
	$MarginContainer/MarginContainer/Panel/MarginContainer/RichTextLabel.text = CustomerDatabase.get_current_customer().get_current_order_dialog()
	_update_make_tea_button()


func _connect_card(card: IngredientCard) -> void:
	card.hover_started.connect(_on_card_hover_started)
	card.hover_ended.connect(_on_card_hover_ended)
	card.selection_requested.connect(_on_card_selection_requested)
	card.removal_requested.connect(_on_card_removal_requested)


func _selected_slots() -> Array[IngredientCard]:
	return [
		$SelectedProp1 as IngredientCard,
		$SelectedProp2 as IngredientCard,
		$SelectedProp3 as IngredientCard
	]


func _restore_selected_ingredients() -> void:
	var saved_ingredients: Array[PropData] = [
		SelectedIngredient.prop1,
		SelectedIngredient.prop2,
		SelectedIngredient.prop3
	]
	var slots := _selected_slots()

	for index in range(slots.size()):
		var slot := slots[index]
		var saved_ingredient := saved_ingredients[index]
		if saved_ingredient == null:
			slot.clear_prop()
			continue

		slot.setup(saved_ingredient)
		slot.enable()
		for child in $GridContainer.get_children():
			var card := child as IngredientCard
			if card.prop_data == saved_ingredient:
				card.disable()
				break


func has_empty_slot() -> bool:
	for slot in _selected_slots():
		if slot.is_empty():
			return true
	return false


func is_recipe_ready() -> bool:
	return not has_empty_slot()


func _on_card_hover_started(card: IngredientCard) -> void:
	_preview_card = card
	$CurrentSelectedProp.texture = card.get_preview_texture()


func _on_card_hover_ended(card: IngredientCard) -> void:
	if _preview_card == card:
		_preview_card = null
		$CurrentSelectedProp.texture = null


func _on_card_selection_requested(card: IngredientCard) -> void:
	if not has_empty_slot():
		return
	for slot in _selected_slots():
		if not slot.is_empty():
			continue
		slot.setup(card.prop_data)
		slot.enable()
		card.play_selection_sound()
		card.disable()
		_update_make_tea_button()
		return


func _on_card_removal_requested(slot: IngredientCard) -> void:
	var removed_prop := slot.prop_data
	for child in $GridContainer.get_children():
		var card := child as IngredientCard
		if card.prop_data == removed_prop:
			card.enable()
			break
	slot.clear_prop()
	UiSounds.play_ingredient_removed()
	_update_make_tea_button()


func _update_make_tea_button() -> void:
	$Button.disabled = not is_recipe_ready()

func _show_unlock_choice() -> void:
	$GridContainer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	UiSounds.play_unlock_reveal()
	var overlay := ColorRect.new()
	overlay.name = "UnlockChoiceOverlay"
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.color = Color(0.05, 0.03, 0.02, 0.68)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(overlay)
	var panel := Panel.new()
	panel.position = Vector2(510, 270)
	panel.size = Vector2(900, 430)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.92549, 0.796078, 0.619608, 1)
	style.corner_radius_top_left = 20
	style.corner_radius_top_right = 20
	style.corner_radius_bottom_left = 20
	style.corner_radius_bottom_right = 20
	panel.add_theme_stylebox_override("panel", style)
	overlay.add_child(panel)
	var title := Label.new()
	title.text = "Choose a new ingredient"
	title.position = Vector2(40, 25)
	title.size = Vector2(820, 60)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_override("font", preload("res://fonts/Laila-Bold.ttf"))
	title.add_theme_font_size_override("font_size", 34)
	title.add_theme_color_override("font_color", Color(0.27, 0.20, 0.10))
	panel.add_child(title)
	var options: Array[String] = _unlock_database().get_pending_options()
	for i in 2:
		var option_button := Button.new()
		option_button.position = Vector2(70 + i * 400, 115)
		option_button.size = Vector2(330, 260)
		option_button.text = options[i]
		option_button.icon = _get_prop_icon(options[i])
		option_button.expand_icon = true
		option_button.add_theme_font_override("font", preload("res://fonts/Laila-Bold.ttf"))
		option_button.add_theme_font_size_override("font_size", 26)
		option_button.pressed.connect(_on_unlock_option_pressed.bind(options[i], overlay))
		panel.add_child(option_button)

func _get_prop_icon(prop_name: String) -> Texture2D:
	for item in props:
		if item.propName == prop_name:
			return load(item.propIconPath)
	return null

func _on_unlock_option_pressed(prop_name: String, overlay: Control) -> void:
	_unlock_database().choose(prop_name)
	overlay.queue_free()
	$GridContainer.mouse_filter = Control.MOUSE_FILTER_PASS
	for child in $GridContainer.get_children():
		var prop := child as IngredientCard
		if _unlock_database().is_unlocked(prop.prop_data.prop_name):
			prop.enable()

func _unlock_database() -> Node:
	return get_node("/root/UnlockDatabase")
func _on_selec_button_pressed():
	SteamSound.play()
	SelectedIngredient.prop1 = $SelectedProp1.prop_data
	SelectedIngredient.prop2 = $SelectedProp2.prop_data
	SelectedIngredient.prop3 = $SelectedProp3.prop_data
	SceneTransition.change_scene_to_file("res://scenes/teashop_scene.tscn")

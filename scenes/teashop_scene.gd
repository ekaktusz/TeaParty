extends Control

const DOUBLE_CLICK_INTERVAL_MS := 400
var last_dialog_click_time := -DOUBLE_CLICK_INTERVAL_MS

func check_ingredients():
	var cust: CustomerData = CustomerDatabase.get_current_customer()
	if cust == null:
		return false

	var selected = SelectedIngredient.get_names()
	if not SelectedIngredient.has_three_distinct_entries():
		return false

	for clue_set in CustomerDatabase.get_revealed_clue_sets():
		var matched = false
		for ingredient_name in selected:
			if clue_set.has(ingredient_name):
				matched = true
				break
		if not matched:
			return false
	return true

# Called when the node enters the scene tree for the first time.
func _ready():
	#print(CustomerDatabase.has_active_customers())
	reset()
	
var over = false
var customer_transition_in_progress := false
var waiting_for_unlock_choice := false
	
func reset():
	if CustomerDatabase.get_current_customer() == null:
		return
	
	$customer.load_from_data(CustomerDatabase.get_current_customer())
	$Button2.disabled = true
	$Button.disabled = true
	$click_for_next.modulate.a = 0

	if (SelectedIngredient.is_valid()): # when return to teashop
		$ing1.texture = load(SelectedIngredient.prop1.propIconPath)
		$ing2.texture = load(SelectedIngredient.prop2.propIconPath)
		$ing3.texture = load(SelectedIngredient.prop3.propIconPath)
		$ing1.visible = true
		$ing2.visible = true
		$ing3.visible = true
		$Button2.disabled = false
		$Button.disabled = false
		$DialogBox.has_more = false
		$DialogBox.set_text(CustomerDatabase.get_current_customer().get_current_order_dialog())
		$DialogBox.tween_complete()
	else:
		$ing1.visible = false
		$ing2.visible = false
		$ing3.visible = false
		$Button.disabled = true
		if (not CustomerDatabase.get_current_customer().introFinished):
			#print(CustomerDatabase.get_current_customer().customerStarterMessage)
			$DialogBox.set_text(CustomerDatabase.get_current_customer().customerStarterMessage)
			#print("hello")
			#print($DialogBox.get_text())
			$DialogBox.has_more = true
		else:
			$DialogBox.set_text(CustomerDatabase.get_current_customer().get_current_order_dialog())
		
		$door_bell.play()
		
	$customer.fade_in()

func on_over_this_customer():
	if customer_transition_in_progress:
		return
	customer_transition_in_progress = true
	$customer.fade_out()
	await get_tree().create_timer(1.0).timeout
	$DialogBox.clear()
	var successful: bool = check_ingredients()
	if successful and get_node("/root/UnlockDatabase").has_pending_choice():
		_show_unlock_choice(successful)
		return
	_finish_customer_transition(successful)

func _finish_customer_transition(successful: bool) -> void:
	if successful:
		end_with_win()
	else:
		end_with_lose()
	SelectedIngredient.reset()
	self.over = false
	reset()
	customer_transition_in_progress = false
	waiting_for_unlock_choice = false

func _show_unlock_choice(successful: bool) -> void:
	waiting_for_unlock_choice = true
	var overlay := ColorRect.new()
	overlay.name = "UnlockChoiceOverlay"
	overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	overlay.color = Color(0.05, 0.03, 0.02, 0.68)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(overlay)
	var outer_panel := Panel.new()
	outer_panel.position = Vector2(510, 245)
	outer_panel.size = Vector2(900, 500)
	var outer_style := StyleBoxFlat.new()
	outer_style.bg_color = Color(0, 0, 0, 1)
	outer_style.corner_radius_top_left = 20
	outer_style.corner_radius_top_right = 20
	outer_style.corner_radius_bottom_left = 20
	outer_style.corner_radius_bottom_right = 20
	outer_panel.add_theme_stylebox_override("panel", outer_style)
	overlay.add_child(outer_panel)
	var panel := Panel.new()
	panel.position = Vector2(5, 5)
	panel.size = Vector2(890, 490)
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.92549, 0.796078, 0.619608, 1)
	panel_style.corner_radius_top_left = 20
	panel_style.corner_radius_top_right = 20
	panel_style.corner_radius_bottom_left = 20
	panel_style.corner_radius_bottom_right = 20
	panel.add_theme_stylebox_override("panel", panel_style)
	outer_panel.add_child(panel)
	var title := Label.new()
	title.text = "A new ingredient is ready to unlock!"
	title.position = Vector2(35, 25)
	title.size = Vector2(830, 55)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_override("font", preload("res://fonts/Laila-Bold.ttf"))
	title.add_theme_font_size_override("font_size", 32)
	title.add_theme_color_override("font_color", Color(0.27, 0.20, 0.10))
	panel.add_child(title)
	var subtitle := Label.new()
	subtitle.text = "Choose one ingredient to add to your collection."
	subtitle.position = Vector2(35, 78)
	subtitle.size = Vector2(830, 40)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_override("font", preload("res://fonts/Laila-Regular.ttf"))
	subtitle.add_theme_font_size_override("font_size", 22)
	subtitle.add_theme_color_override("font_color", Color(0.27, 0.20, 0.10))
	panel.add_child(subtitle)
	var options: Array[String] = get_node("/root/UnlockDatabase").get_pending_options()
	var unlock_preview := TextureRect.new()
	unlock_preview.position = Vector2(1430, 250)
	unlock_preview.size = Vector2(320, 430)
	unlock_preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	unlock_preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	unlock_preview.mouse_filter = Control.MOUSE_FILTER_IGNORE
	unlock_preview.visible = false
	overlay.add_child(unlock_preview)
	for i in 2:
		var choice := VBoxContainer.new()
		choice.position = Vector2(70 + i * 400, 140)
		choice.size = Vector2(330, 285)
		choice.alignment = BoxContainer.ALIGNMENT_CENTER
		choice.add_theme_constant_override("separation", 8)
		var icon_button := TextureButton.new()
		icon_button.custom_minimum_size = Vector2(210, 210)
		icon_button.texture_normal = _get_unlock_prop_icon(options[i])
		icon_button.ignore_texture_size = true
		icon_button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		icon_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		icon_button.pivot_offset = Vector2(105, 105)
		icon_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		icon_button.mouse_entered.connect(_on_unlock_icon_hover.bind(icon_button, true))
		icon_button.mouse_exited.connect(_on_unlock_icon_hover.bind(icon_button, false))
		icon_button.mouse_entered.connect(_on_unlock_preview_hover.bind(unlock_preview, _get_unlock_prop_card(options[i]), true))
		icon_button.mouse_exited.connect(_on_unlock_preview_hover.bind(unlock_preview, "", false))
		icon_button.pressed.connect(_on_unlock_option_pressed.bind(options[i], overlay, successful))
		choice.add_child(icon_button)
		var name_label := Label.new()
		name_label.text = options[i]
		name_label.custom_minimum_size = Vector2(330, 45)
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_label.add_theme_font_override("font", preload("res://fonts/Laila-Bold.ttf"))
		name_label.add_theme_font_size_override("font_size", 26)
		name_label.add_theme_color_override("font_color", Color(0.27, 0.20, 0.10))
		choice.add_child(name_label)
		panel.add_child(choice)

func _on_unlock_icon_hover(icon_button: TextureButton, hovered: bool) -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	tween.tween_property(icon_button, "scale", Vector2(1.08, 1.08) if hovered else Vector2.ONE, 0.12)
	tween.tween_property(icon_button, "modulate", Color(1.18, 1.18, 1.18, 1.0) if hovered else Color.WHITE, 0.12)

func _on_unlock_preview_hover(preview: TextureRect, card_path: String, hovered: bool) -> void:
	if hovered:
		preview.texture = load(card_path)
		preview.visible = true
	else:
		preview.visible = false

func _get_unlock_prop_icon(prop_name: String) -> Texture2D:
	# Use the same ingredient definitions as the tea-making scene.
	var icon_map := {
		"Cinnamon": "res://images/props/cinnamon.png", "Lizard Liver": "res://images/props/lizard_liver.png",
		"Poppy Seed": "res://images/props/poppy_seed.png", "Honey": "res://images/props/honey.png",
		"Vinegar": "res://images/props/vinegar.png", "Unicorn Feather": "res://images/props/unicorn_feather.png",
		"Jasmine Petal": "res://images/props/jasmine.png", "Whisky": "res://images/props/whisky.png",
		"Vanilla": "res://images/props/vanilla.png", "Chili": "res://images/props/chili.png",
		"Chocolate": "res://images/props/chocolate.png", "Herbal Tea": "res://images/props/herbaltea.png",
		"Water of Life": "res://images/props/water_of_life.png", "Cloves": "res://images/props/cloves.png",
		"Ginger": "res://images/props/ginger.png", "Orange Peels": "res://images/props/orange_peel.png",
		"Rose Petal": "res://images/props/rose.png", "Mate Tea": "res://images/props/matetea.png",
		"White Tea": "res://images/props/whitetea.png", "Roiboss": "res://images/props/roiboss.png"
	}
	return load(icon_map.get(prop_name, ""))

func _get_unlock_prop_card(prop_name: String) -> String:
	var card_map := {
		"Cinnamon": "res://images/cards/cinnamon.png", "Lizard Liver": "res://images/cards/lizard_liver.png",
		"Poppy Seed": "res://images/cards/poppy_seed.png", "Honey": "res://images/cards/honey.png",
		"Vinegar": "res://images/cards/vinegar.png", "Unicorn Feather": "res://images/cards/unicorn_feather.png",
		"Jasmine Petal": "res://images/cards/jasmine_petal.png", "Whisky": "res://images/cards/whisky.png",
		"Vanilla": "res://images/cards/vanilla.png", "Chili": "res://images/cards/chili.png",
		"Chocolate": "res://images/cards/chocolate.png", "Herbal Tea": "res://images/cards/herbal_tea.png",
		"Water of Life": "res://images/cards/water_of_life.png", "Cloves": "res://images/cards/cloves.png",
		"Ginger": "res://images/cards/ginger.png", "Orange Peels": "res://images/cards/orange_peels.png",
		"Rose Petal": "res://images/cards/rose_petal.png", "Mate Tea": "res://images/cards/mate_tea.png",
		"White Tea": "res://images/cards/white_tea.png", "Roiboss": "res://images/cards/roiboss.png"
	}
	return card_map.get(prop_name, "")

func _on_unlock_option_pressed(prop_name: String, overlay: Control, successful: bool) -> void:
	get_node("/root/UnlockDatabase").choose(prop_name)
	overlay.queue_free()
	_finish_customer_transition(successful)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $DialogBox.is_complete and not $DialogBox.has_more and not self.over and not $customer.fading:
		$Button.disabled = false
	if self.over and not $customer.fading and $DialogBox.is_complete and $click_for_next.modulate.a == 0:
		show_next_customer_button()
		
func end_with_win():
	var customer = CustomerDatabase.get_current_customer()
	if customer == null:
		return

	customer.customerCurrentLevel += 1
	#print (customer.customerCurrentLevel)
	if customer.customerCurrentLevel == 3:
		CustomerDatabase.remove_current_customer()
	if not CustomerDatabase.has_active_customers():
		#await get_tree().create_timer(2.0).timeout
		BgNoises.stop()
		SceneTransition.change_scene_to_file("res://scenes/ending_scene.tscn")
	else:
		CustomerDatabase.next_customer(customer)
	pass
	
func end_with_lose():
	CustomerDatabase.next_customer(CustomerDatabase.get_current_customer())
	pass
	
func show_next_customer_button():
	$click_for_next.modulate.a = 0
	var target_color = Color(1, 1, 1, 1)
	var tween = get_tree().create_tween()
	tween.tween_property($click_for_next, "modulate", target_color, 1)
	
func hide_next_customer_button():
	$click_for_next.modulate.a = 1
	var target_color = Color(1, 1, 1, 0)
	var tween = get_tree().create_tween()
	tween.tween_property($click_for_next, "modulate", target_color, 1)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			# The notebook is a modal overlay only while it is open. The toggle
			# button itself must not advance the customer's dialogue.
			if $NotebookOverlay.is_open:
				return
			var mouse_position: Vector2 = event.position
			if Rect2(28, 24, 190, 62).has_point(mouse_position):
				return
			if SceneTransition.is_transitioning or customer_transition_in_progress or $customer.fading:
				return
			if not $DialogBox.is_complete:
				var current_time := Time.get_ticks_msec()
				var is_double_click: bool = event.double_click or current_time - last_dialog_click_time <= DOUBLE_CLICK_INTERVAL_MS
				last_dialog_click_time = current_time
				if is_double_click:
					$DialogBox.reveal_text()
					return
			if $DialogBox.is_complete and not CustomerDatabase.get_current_customer().introFinished:
				CustomerDatabase.get_current_customer().introFinished = true
				$DialogBox.has_more = false
				$DialogBox.reset(CustomerDatabase.get_current_customer().customerOrderDialogs[0]) #ugyis csak az elsonel kell
			if self.over and not $customer.fading and $DialogBox.is_complete:
				on_over_this_customer()
				hide_next_customer_button()

func play_winning_dialog():
	var cust: CustomerData = CustomerDatabase.get_current_customer()
	$DialogBox.reset(cust.customerOrderAcceptDialogs[cust.customerCurrentLevel])
	$DialogBox.set_feedback(true)
	self.over = true
	
func play_losing_dialog():
	var cust: CustomerData = CustomerDatabase.get_current_customer()
	$DialogBox.reset(cust.customerOrderRejectionDialogs[cust.customerCurrentLevel])
	$DialogBox.set_feedback(false)
	self.over = true

func _on_button_serve_pressed():
	if customer_transition_in_progress or SceneTransition.is_transitioning or $customer.fading:
		return
	var successful: bool = check_ingredients()
	_record_tea_attempt(successful)
	if successful:
		get_node("/root/UnlockDatabase").register_correct_round()
		$sip_accept.play()
		play_winning_dialog()
	else:
		$sip_decline.play()
		play_losing_dialog()
	$Button2.disabled = true
	$Button.disabled = true
	$ing1.visible = false
	$ing2.visible = false
	$ing3.visible = false
	
	pass # Replace with function body.

func _record_tea_attempt(successful: bool) -> void:
	var customer_data := CustomerDatabase.get_current_customer()
	if customer_data == null or not SelectedIngredient.is_valid():
		return
	var icon_paths: Array[String] = [
		SelectedIngredient.prop1.propIconPath,
		SelectedIngredient.prop2.propIconPath,
		SelectedIngredient.prop3.propIconPath
	]
	customer_data.add_tea_history(icon_paths, successful)
	$NotebookOverlay.refresh()

func _on_button_select_ing_pressed():
	if customer_transition_in_progress or SceneTransition.is_transitioning or $customer.fading:
		return
	SceneTransition.change_scene_to_file("res://scenes/teamaking_scene.tscn")
	pass # Replace with function body.

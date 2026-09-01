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
	$customer.fade_out()
	await get_tree().create_timer(1.0).timeout
	$DialogBox.clear()
	if check_ingredients():
		end_with_win()
	else:
		end_with_lose()
	SelectedIngredient.reset()
	self.over = false
	reset()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
	$DialogBox.reset(cust.customerOrderAcceptDialogs[cust.customerCurrentLevel] + " 😄")
	$DialogBox.set_feedback(true)
	self.over = true
	
func play_losing_dialog():
	var cust: CustomerData = CustomerDatabase.get_current_customer()
	$DialogBox.reset(cust.customerOrderRejectionDialogs[cust.customerCurrentLevel] + " 😠")
	$DialogBox.set_feedback(false)
	self.over = true

func _on_button_serve_pressed():
	if check_ingredients():
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

func _on_button_select_ing_pressed():
	SceneTransition.change_scene_to_file("res://scenes/teamaking_scene.tscn")
	pass # Replace with function body.

extends Control

func check_ingredients():
	var cust: CustomerData = CustomerDatabase.getCurrentCustomer()
	return CustomerDatabase.getCurrentCustomer().correctItems[cust.customerCurrentLevel].has(SelectedIngredient.prop1.propName) or CustomerDatabase.getCurrentCustomer().correctItems[cust.customerCurrentLevel].has(SelectedIngredient.prop2.propName) or CustomerDatabase.getCurrentCustomer().correctItems[cust.customerCurrentLevel].has(SelectedIngredient.prop3.propName)

# Called when the node enters the scene tree for the first time.
func _ready():
	print(CustomerDatabase.customers.size())
	BgNoises.play()
	reset()
	
var over = false
	
func reset():
	if CustomerDatabase.getCurrentCustomer() == null:
		return
	
	$customer.load_from_data(CustomerDatabase.getCurrentCustomer())
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
		$DialogBox.set_text(CustomerDatabase.getCurrentCustomer().get_current_order_dialog())
		$DialogBox.tween_complete()
	else:
		$ing1.visible = false
		$ing2.visible = false
		$ing3.visible = false
		$Button.disabled = true
		if (not CustomerDatabase.getCurrentCustomer().introFinished):
			print(CustomerDatabase.getCurrentCustomer().customerStarterMessage)
			$DialogBox.set_text(CustomerDatabase.getCurrentCustomer().customerStarterMessage)
			print("hello")
			print($DialogBox.get_text())
			$DialogBox.has_more = true
		else:
			$DialogBox.set_text(CustomerDatabase.getCurrentCustomer().get_current_order_dialog())
		
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
	CustomerDatabase.getCurrentCustomer().customerCurrentLevel += 1
	print (CustomerDatabase.getCurrentCustomer().customerCurrentLevel)
	if CustomerDatabase.getCurrentCustomer().customerCurrentLevel == 3:
		CustomerDatabase.removeCurrentCustomer()
	if CustomerDatabase.customers.size() == 0:
		#await get_tree().create_timer(2.0).timeout
		BgNoises.stop()
		SceneTransition.change_scene_to_file("res://scenes/ending_scene.tscn")
	else:
		CustomerDatabase.nextCustomer()
	pass
	
func end_with_lose():
	CustomerDatabase.nextCustomer()
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
		if event.pressed:
			if $DialogBox.is_complete and not CustomerDatabase.getCurrentCustomer().introFinished:
				CustomerDatabase.getCurrentCustomer().introFinished = true
				$DialogBox.has_more = false
				$DialogBox.reset(CustomerDatabase.getCurrentCustomer().customerOrderDialogs[0]) #ugyis csak az elsonel kell
			if self.over and not $customer.fading and $DialogBox.is_complete:
				on_over_this_customer()
				hide_next_customer_button()

func play_winning_dialog():
	var cust: CustomerData = CustomerDatabase.getCurrentCustomer()
	$DialogBox.reset(cust.customerOrderAcceptDialogs[cust.customerCurrentLevel])
	self.over = true
	
func play_losing_dialog():
	var cust: CustomerData = CustomerDatabase.getCurrentCustomer()
	$DialogBox.reset(cust.customerOrderRejectionDialogs[cust.customerCurrentLevel])
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

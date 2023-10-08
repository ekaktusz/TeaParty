extends Control

func check_ingredients():
	var cust: CustomerData = CustomerDatabase.getCurrentCustomer()
	return CustomerDatabase.getCurrentCustomer().correctItems[cust.customerCurrentLevel].has(SelectedIngredient.prop1.propName) or CustomerDatabase.getCurrentCustomer().correctItems[cust.customerCurrentLevel].has(SelectedIngredient.prop2.propName) or CustomerDatabase.getCurrentCustomer().correctItems[cust.customerCurrentLevel].has(SelectedIngredient.prop3.propName)

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()
	
var over = false
	
func reset():
	$customer.load_from_data(CustomerDatabase.getCurrentCustomer())
	$Button2.disabled = true
	$Button.disabled = true

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
		if (not CustomerDatabase.getCurrentCustomer().introFinished):
			print(CustomerDatabase.getCurrentCustomer().customerStarterMessage)
			$DialogBox.set_text(CustomerDatabase.getCurrentCustomer().customerStarterMessage)
			print("hello")
			print($DialogBox.get_text())
			$DialogBox.has_more = true
		else:
			$DialogBox.set_text(CustomerDatabase.getCurrentCustomer().get_current_order_dialog())
		
	$customer.fade_in()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $DialogBox.is_complete and not $DialogBox.has_more and not self.over:
		$Button.disabled = false
	
	if self.over and not $customer.fading and $DialogBox.is_complete:
		$customer.fade_out()
		await get_tree().create_timer(2.0).timeout
		
		if check_ingredients():
			end_with_win()
		else:
			end_with_lose()
		SelectedIngredient.reset()
		self.over = false
		reset()
	
		
func end_with_win():
	CustomerDatabase.getCurrentCustomer().customerCurrentLevel += 1
	var nextCustomerId: int 
	while (nextCustomerId == CustomerDatabase.currentCustomer):
		nextCustomerId = randi() % CustomerDatabase.customers.size()
	
	CustomerDatabase.currentCustomer = nextCustomerId
	pass
	
func end_with_lose():
	var nextCustomerId:int 
	while (nextCustomerId == CustomerDatabase.currentCustomer):
		nextCustomerId = randi() % CustomerDatabase.customers.size()
		
	CustomerDatabase.currentCustomer = nextCustomerId
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if $DialogBox.is_complete and not CustomerDatabase.getCurrentCustomer().introFinished:
				CustomerDatabase.getCurrentCustomer().introFinished = true
				$DialogBox.has_more = false
				$DialogBox.reset(CustomerDatabase.getCurrentCustomer().customerOrderDialogs[0]) #ugyis csak az elsonel kell

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
		play_winning_dialog()
	else:
		play_losing_dialog()
	$Button2.disabled = true
	$ing1.visible = false
	$ing2.visible = false
	$ing3.visible = false
	pass # Replace with function body.

func _on_button_select_ing_pressed():
	SceneTransition.change_scene_to_file("res://scenes/teamaking_scene.tscn")
	pass # Replace with function body.

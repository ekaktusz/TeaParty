extends Node

var _player_current_level: int = 0 # only grow if all characthers reached the next level

var _inactive_customers: Array[CustomerData] = []
var _active_customers: Array[CustomerData] = []
var _current_customer_id: int = 0

func _clone_customer_templates() -> Array[CustomerData]:
	var cloned: Array[CustomerData] = []
	for customer in _customers:
		var copy := CustomerData.new(
			customer.customerName,
			customer.customerStarterMessage,
			customer.customerOrderDialogs.duplicate(true),
			customer.customerOrderRejectionDialogs.duplicate(true),
			customer.customerOrderAcceptDialogs.duplicate(true),
			customer.customerImage,
			customer.correctItems.duplicate(true)
		)
		copy.customerCurrentLevel = customer.customerCurrentLevel
		copy.introFinished = customer.introFinished
		cloned.append(copy)
	return cloned

var _customers: Array[CustomerData] = [
	CustomerData.new(
		"Grumpy Lumberjack",
		"Brr, the weather is rather familiar, but this country has nothing to offer me. Pff, a tea shop?!? The audacity...",
		[
			"I feel tired, let's see if you could give me some [b][i]caffeine[/i][/b]. \n[b]Select ingredients by clicking on them. Read the descriptions if you are unsure which one to use.[/b]",
			"So you think you know tea, lad? [b]Same tea as last time[/b], but make it [b][i]spicy[/i][/b]!",
			"Gives me [b]energy[/b], has some [b]spice[/b], but [b][i]the taste of home[/i][/b] is what your tea is still missing."
		],
		[
			"Bloody hell, this isn't what I asked for, mate! ",
			"Sorry... That's just not my cup of tea.",
			"Bleee, this is far from the King's standard, innit?"
		],
		[
			"Just what the doctor ordered!",
			"Sugar, spice, and everything nice! (Except for the sugar, let's keep that for the Americans.)",
			"Oh my Lord, you did it. It's bloody brilliant. I must assume you also have some history exploiting other sub-continents for centuries to have this level of knowledge of tea making in your blood."
		],
		"res://images/characthers/CozyJam2023_lumberjack.png",
		[
			["Black Tea", "Mate Tea"],
			["Bergamot", "Cloves"],
			["Milk", "Whisky"]
		]
	),
	CustomerData.new(
		"Heartbroken Butcher",
		"Greetings! You know me, you buy meat at my shop. Anyway... those were better days... My gal just left me! What am I supposed to do now?!",
		[
			"To be honest I don't even care, just give me something that resembles the [b]colors of different seasons[/b], when life was happier...",
			"Hey... Now that you got the [b]colors[/b] right, could you put in some [b]sour stuff[/b] to better match my mood?",
			"I like the [b]color[/b], the [b]sourness[/b] is just fine, and I don't need salt, my tears are enought... Oh I see a [b]girls name[/b] in your inventory though..."
		],
		[
			"It tastes just how I feel. Awful!",
			"But not like this! Eww...",
			"Pfff, what is this, poision? I wish, that would end my suffer."
		],
		[
			"From winter to spring, we were together. Thanks!",
			"If I could be enthusiastic about anything, I would really like this tea.",
			"Hmm...it....works? My hearth is healed, my mind is cleared. You are a magician young man. I'm ready to swipe again. Who's that chick in the corner?"
		],
		"res://images/characthers/CozyJam2023_Butcher_happy.png",
		[
			["Green Tea", "White Tea"],
			["Lemon", "Vinegar"],
			["Rose Petal", "Jasmine Petal"]
		]
	),
	CustomerData.new(
		"Little Witch",
		"I gotta get my homework done quick, or my master will surely turn me into a mouse... But maybe a cup of tea could help the creative juices flowing. ",
		[
			"Hey, mister. I wanna drink something that [b][i]makes me extra jumpy[/i][/b].",
			"I loved the [b]jumpy juice[/b]! Can you also add something [b][i]small and adorable[/i][/b] to it (like me)? Pretty please!",
			"Okay. [b]Jumpy[/b] - check. [b]Smol[/b] - check. Now, I want you to add something [b][i]MAGICAL[/i][/b] to the mix!"
		],
		[
			"Eww! I don't want it!",
			"Mom, can you come and pick me up? 🙁",
			"That ain't magic, mister. "
		],
		[
			"Ah! That sure was something, mister.",
			"Ah! Just what I needed.",
			"Muhahaha! FOOL! You did it! YOU DID IT FOR ME! You finished my homework without even knowing. See ya, nerd!"
		],
		"res://images/characthers/CozyJam2023_Kid_happy.png",
		[
			["Frogleg", "Roiboss"],
			["Lizard Liver", "Poppy Seed"],
			["Unicorn Feather", "Water of Life"]
		]
	),
		CustomerData.new(
		"Painter Girl",
		"I love the smell of rain, but I just can't paint anything in this weather.",
		[
			"Hi! I'm feeling [b][i]fruity[/i][/b] today. Hit me with your best fruit tea.",
			"I loved the [b]fruits[/b] last time, but I'm also looking forward to the holiday season. Can you make me something that's also a bit [b][i]festive[/i][/b], please?",
			"I know this will sound weird, but... Can you make me a [b]festive[/b], [b]fruit tea[/b], that also tastes a bit like a [b][i]bowl of ice cream[/i][/b]?"
		],
		[
			"Thanks, but no thanks.",
			"Nope.",
			"No. Just no."
		],
		[
			"Thanks, man.",
			"OMG! I Love it!",
			"AMAZING! Huh, I spent all day in here, and managed to paint some pretty cool stuff after all. Now, can you tell me a bit more about that handsome butcher boy?;)"
		],
		"res://images/characthers/CozyJam2023_paintergirl.png",
		[
			["Dried Fruits", "Orange Peels"],
			["Cinnamon", "Nutmeg"],
			["Vanilla", "Chocolate"]
		]
	),
		CustomerData.new(
		"Flower Woman",
		"What a lovely little tea shop. I can't sell my flowers, because it's so cold outside. But maybe I can warm myself up here, and go back to work refreshed.",
		[
			"Good morning, dear. I feel a chill in my bones. Can I ask for something that [b][i]warms[/i][/b] me up?",
			"Loved the [b]warmth[/b] of that tea. But I do like something [b][i]sugary[/i][/b] in my cup. (Just don't tell my husband. We're on a diet.)",
			"I loved the [b]warmth[/b] and the [b]sweetness[/b], but I'm still missing something. If it isn't too much trouble, can you add something with a bit more... [b][i]heat[/i][/b]?"
		],
		[
			"Oh, dear. I still feel cold...",
			"That is not the sweetness I was looking for.",
			"Splendid work, truly. Just not for me."
		],
		[
			"Lovely. Just like my nana used to make.",
			"My goodness! Darling, you're a natural!",
			"HELL YEAH, give me more of those Scoville levels!!! WHO WANTS SOME FLOWERS???"
		],
		"res://images/characthers/CozyJam2023_granny.png",
		[
			["Chamomile", "Herbal Tea"],
			["Honey", "Maple Syrup"],
			["Chili", "Ginger"]
		]
	),
		CustomerData.new(
		"Punk",
		"Oi, where am I? Had a banger last night with me mates. Got any change? Need for the bus.",
		[
			"Oi barman, give me a [b][i]beer[/i][/b]... or [b][i]whatever[/i][/b].",
			"Can I get another [b][i]beer[/i][/b], boss? ",
			"Can me taste another of your [b][i]special ale[/i][/b] please?"
		],
		[
			"Eww! I don't want it!",
			"Mom, can you come and pick me up? 🙁",
			"That ain't magic, mister. "
		],
		[
			"A drink is a drink alright. (slurp)",
			"Cheers! (slurp) It was decent, mate. ",
			"You wasn't kidding, this is the tastiest beverage kissed me lips in a long time. I need to bring me mates to your fine establishment."
		],
		"res://images/characthers/CozyJam2023_punk.png",
		[
			["Chili", "Ginger", "Honey", "Maple Syrup", "Chamomile", "Herbal Tea", "Vanilla", "Chocolate", "Cinnamon", "Nutmeg", "Dried Fruits", "Orange Peels", "Unicorn Feather", "Water of Life", "Lizard Liver", "Poppy Seed", "Frogleg", "Roiboss", "Black Tea", "Mate Tea", "Bergamot", "Cloves", "Milk", "Whisky", "Green Tea", "White Tea", "Lemon", "Vinegar", "Rose Petal", "Jasmine Petal"],
			["Chili", "Ginger", "Honey", "Maple Syrup", "Chamomile", "Herbal Tea", "Vanilla", "Chocolate", "Cinnamon", "Nutmeg", "Dried Fruits", "Orange Peels", "Unicorn Feather", "Water of Life", "Lizard Liver", "Poppy Seed", "Frogleg", "Roiboss", "Black Tea", "Mate Tea", "Bergamot", "Cloves", "Milk", "Whisky", "Green Tea", "White Tea", "Lemon", "Vinegar", "Rose Petal", "Jasmine Petal"],
			["Chili", "Ginger", "Honey", "Maple Syrup", "Chamomile", "Herbal Tea", "Vanilla", "Chocolate", "Cinnamon", "Nutmeg", "Dried Fruits", "Orange Peels", "Unicorn Feather", "Water of Life", "Lizard Liver", "Poppy Seed", "Frogleg", "Roiboss", "Black Tea", "Mate Tea", "Bergamot", "Cloves", "Milk", "Whisky", "Green Tea", "White Tea", "Lemon", "Vinegar", "Rose Petal", "Jasmine Petal"]
		]
	)
]
func _ready() -> void:
	reset_customer_progress()

func reset_customer_progress() -> void:
	_player_current_level = 0
	_inactive_customers.clear()
	_active_customers = _clone_customer_templates()
	for customer in _active_customers:
		customer.reset()

	# _active_customers should not be empty, just safety
	_current_customer_id = 0


func get_current_customer() -> CustomerData:
	if _active_customers.is_empty():
		return null
	return _active_customers[_current_customer_id]


func has_active_customers() -> bool:
	return not _active_customers.is_empty()


func remove_current_customer() -> CustomerData:
	var customer = get_current_customer()
	if customer == null:
		return null

	_inactive_customers.append(customer)
	_active_customers.remove_at(_current_customer_id)
	_current_customer_id = 0
	return customer

func get_revealed_clue_sets() -> Array:
	var customer = get_current_customer()
	if customer == null:
		return []

	var revealed_clues = []
	for index in range(0, customer.customerCurrentLevel + 1):
		if index >= customer.correctItems.size():
			break
		revealed_clues.append(customer.correctItems[index])
	return revealed_clues

func next_customer(excluded_customer: CustomerData = null) -> void:
	if _active_customers.is_empty():
		_current_customer_id = 0
		return

	var eligible_customers := _get_next_level_customers()
	if eligible_customers.is_empty():
		_player_current_level = _get_lowest_remaining_level()
		eligible_customers = _get_customers_at_current_level()

	if eligible_customers.is_empty():
		_current_customer_id = 0
		return

	_current_customer_id = _choose_customer_id(eligible_customers, excluded_customer)

# Internal helpers

func _get_next_level_customers() -> Array[CustomerData]:
	var eligible_customers: Array[CustomerData] = _get_customers_at_current_level()
	if eligible_customers.is_empty():
		_player_current_level = _get_lowest_remaining_level()
		eligible_customers = _get_customers_at_current_level()
	return eligible_customers

func _get_customers_at_current_level() -> Array[CustomerData]:
	var customers_at_current_level: Array[CustomerData] = []
	for customer in _active_customers:
		if customer.customerCurrentLevel == _player_current_level:
			customers_at_current_level.append(customer)
	return customers_at_current_level

func _get_lowest_remaining_level() -> int:
	var lowest_level: int = _active_customers[0].customerCurrentLevel
	for customer in _active_customers:
		lowest_level = min(lowest_level, customer.customerCurrentLevel)
	return lowest_level

func _choose_customer_id(
	eligible_customers: Array[CustomerData],
	excluded_customer: CustomerData
) -> int:
	var candidates: Array[CustomerData] = eligible_customers.duplicate()
	if excluded_customer != null and candidates.size() > 1:
		candidates.erase(excluded_customer)

	var selected_customer: CustomerData = candidates.pick_random()
	return _get_id_for_customer(selected_customer)

func _get_id_for_customer(customer_data: CustomerData) -> int:
	for i in _active_customers.size():
		var customer = _active_customers[i]
		if customer == customer_data:
			return i

	assert(false, "selected customer is not active")
	return -1

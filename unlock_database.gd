extends Node

const INITIAL_UNLOCKED := ["Black Tea", "Green Tea", "Frogleg", "Dried Fruits", "Chamomile", "Lemon", "Milk", "Bergamot", "Nutmeg", "Maple Syrup"]
const UNLOCK_ORDER := ["Cinnamon", "Lizard Liver", "Poppy Seed", "Honey", "Vinegar", "Unicorn Feather", "Jasmine Petal", "Whisky", "Vanilla", "Chili", "Chocolate", "Herbal Tea", "Water of Life", "Cloves", "Ginger", "Orange Peels", "Rose Petal", "Mate Tea", "White Tea", "Roiboss"]

var unlocked: Dictionary = {}
var pool: Array[String] = []
var cooldown: Dictionary = {}
var pending_options: Array[String] = []

func _ready() -> void:
	reset()

func reset() -> void:
	unlocked.clear()
	for name in INITIAL_UNLOCKED:
		unlocked[name] = true
	pool.clear()
	for ingredient_name in UNLOCK_ORDER:
		pool.append(ingredient_name)
	cooldown.clear()
	pending_options.clear()

func is_unlocked(name: String) -> bool:
	return unlocked.has(name)

func get_unlocked_names_in_order() -> Array[String]:
	var result: Array[String] = []
	for name in INITIAL_UNLOCKED:
		if is_unlocked(name):
			result.append(name)
	for name in UNLOCK_ORDER:
		if is_unlocked(name):
			result.append(name)
	return result

func register_correct_round(next_required_group: Array[String] = []) -> void:
	if pending_options.is_empty() and not pool.is_empty():
		pending_options = _build_options(next_required_group)

func has_pending_choice() -> bool:
	return pending_options.size() == 2

func get_pending_options() -> Array[String]:
	var result: Array[String] = []
	for option in pending_options:
		result.append(option)
	return result

func choose(name: String) -> void:
	if not pending_options.has(name):
		return
	var rejected: Array[String] = pending_options.duplicate()
	rejected.erase(name)
	pool.erase(name)
	unlocked[name] = true
	for option in rejected:
		cooldown[option] = 1
	pending_options.clear()

func _build_options(next_required_group: Array[String]) -> Array[String]:
	# A customer who has just advanced must be able to satisfy their newly
	# revealed clue when they next appear in the random rotation. Offering both
	# alternatives means either player choice keeps that next round solvable.
	var required_options: Array[String] = []
	for name in next_required_group:
		if pool.has(name) and not is_unlocked(name):
			required_options.append(name)
	if required_options.size() >= 2:
		var required_pair: Array[String] = [required_options[0], required_options[1]]
		_advance_cooldowns()
		return required_pair

	var options: Array[String] = []
	for name in pool:
		if cooldown.get(name, 0) > 0:
			continue
		options.append(name)
		if options.size() == 2:
			break
	_advance_cooldowns()
	return options

func _advance_cooldowns() -> void:
	for name in cooldown.keys():
		if cooldown[name] > 0:
			cooldown[name] -= 1

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
	)
]

# Called when the node enters the scene tree for the first time.
func _ready():
	for item in self.props:
		var prop = PropMenu.instantiate()
		prop.load(item)
		$GridContainer.add_child(prop)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

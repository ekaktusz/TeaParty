extends MarginContainer

var mouseOnCard: bool = false
const DEFAULT_ALPHA: float = 150. / 255.
var hoverOpacityChangeSpeed: float = 0.03

var propData: PropData

# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureRect2.modulate.a = DEFAULT_ALPHA
	print("hmm")
	pass # Replace with function body.

func load(propdata: PropData):
	self.propData = propdata
	$TextureRect.texture = load(propdata.propIconPath)
	$TextureRect2.texture = load(propdata.propIconPath)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mouseOnCard:
		var parentScene = get_parent().get_parent()
		var currentSelectedProp = parentScene.get_node("CurrentSelectedProp")
		currentSelectedProp.texture = load(self.propData.propCardPath)
		print(currentSelectedProp.name)
		if $TextureRect2.modulate.a > 0:
			$TextureRect2.modulate.a -= hoverOpacityChangeSpeed
	else:
		if $TextureRect2.modulate.a <= DEFAULT_ALPHA:
			$TextureRect2.modulate.a += hoverOpacityChangeSpeed
	pass
	
func _input(event):
	if event is InputEventMouse:
		if $TextureRect.get_global_rect().has_point(event.position):
			print("asd3")
			mouseOnCard = true
		else:
			mouseOnCard = false
	pass # Replace with function body.

extends MarginContainer

var mouseOnCard: bool = false
const DEFAULT_ALPHA: float = 100. / 255.
var hoverOpacityChangeSpeed: float = 0.09

var propData: PropData

var disabled = false
var locked = false
var hover_tween: Tween
var notRealShit = false # meaning that its not in the inventory but it's a dummy object in the bottom showing one of the selected items

# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureRect2.modulate.a = DEFAULT_ALPHA
	pivot_offset = Vector2(65, 65)
	#print("hmm")
	pass # Replace with function body.

func load(propdata: PropData):
	self.propData = propdata
	$TextureRect.texture = load(propdata.propIconPath)
	$TextureRect2.texture = load(propdata.propIconPath)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if disabled:
		return
	
	if mouseOnCard:
		var parentScene = get_parent().get_parent()
		if self.notRealShit:
			parentScene = get_parent()
		var currentSelectedProp = parentScene.get_node("CurrentSelectedProp")
		currentSelectedProp.texture = load(self.propData.propCardPath)
		#print(currentSelectedProp.name)
			
		if $TextureRect2.modulate.a > 0:
			$TextureRect2.modulate.a -= hoverOpacityChangeSpeed
	else:
		if $TextureRect2.modulate.a <= DEFAULT_ALPHA:
			$TextureRect2.modulate.a += hoverOpacityChangeSpeed
	pass
	
func _input(event):
	if disabled:
		return
	
	if event is InputEventMouse:
		if $TextureRect.get_global_rect().has_point(event.position):
			#print("asd3")
			if not mouseOnCard:
				_set_hover_visual(true)
			mouseOnCard = true
		else:
			if mouseOnCard:
				_clear_current_card()
				_set_hover_visual(false)
			mouseOnCard = false
	
	if event is InputEventMouseButton:
		if get_global_rect().has_point(event.position) and event.pressed:
			if not self.notRealShit:
				var parentScene = get_parent().get_parent()
				if parentScene.can_select():
					_clear_current_card()
					self.disable()
					$blub.play()
					parentScene.select_prop(self.propData)
			else:
				get_parent().return_prop(self.propData)
				self.disable()
	pass # Replace with function body.

func disable():
	locked = false
	disabled = true
	$TextureRect2.modulate.a = 0
	_set_hover_visual(false)
	$TextureRect.modulate.a = 0
	
func enable():
	locked = false
	disabled = false
	$TextureRect2.modulate.a = DEFAULT_ALPHA
	$TextureRect.modulate.a = 1
	_set_hover_visual(false)

func lock():
	locked = true
	disabled = true
	# Keep the card visible, but make it unmistakably unavailable.
	$TextureRect.modulate = Color(0.16, 0.16, 0.16, 0.92)
	$TextureRect2.modulate.a = 0

func _clear_current_card() -> void:
	var parent_scene = get_parent().get_parent()
	if self.notRealShit:
		parent_scene = get_parent()
	var preview = parent_scene.get_node_or_null("CurrentSelectedProp")
	if preview != null:
		preview.texture = null

func _set_hover_visual(hovered: bool) -> void:
	if hover_tween != null:
		hover_tween.kill()
	hover_tween = create_tween()
	hover_tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	hover_tween.tween_property(self, "scale", Vector2(1.06, 1.06) if hovered else Vector2.ONE, 0.12)

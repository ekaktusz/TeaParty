class_name IngredientCard
extends MarginContainer

signal hover_started(card)
signal hover_ended(card)
signal selection_requested(card)
signal removal_requested(card)

const DEFAULT_ALPHA := 100.0 / 255.0
const HOVER_DURATION := 0.12
const HOVER_SCALE := Vector2(1.06, 1.06)

var prop_data: PropData
var is_selected_slot := false
var is_disabled := false
var is_locked := false

var _is_hovered := false
var _hover_tween: Tween
var _preview_texture: Texture2D


func _ready() -> void:
	pivot_offset = Vector2(65, 65)
	mouse_filter = Control.MOUSE_FILTER_STOP
	$TextureRect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$TextureRect2.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$TextureRect2.modulate.a = DEFAULT_ALPHA
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)


func setup(data: PropData) -> void:
	prop_data = data
	_preview_texture = null
	var icon_texture := load(prop_data.prop_icon_path) as Texture2D
	$TextureRect.texture = icon_texture
	$TextureRect2.texture = icon_texture


func clear_prop() -> void:
	disable()
	prop_data = null
	_preview_texture = null
	$TextureRect.texture = null
	$TextureRect2.texture = null


func get_preview_texture() -> Texture2D:
	if _preview_texture == null and prop_data != null:
		_preview_texture = load(prop_data.prop_card_path) as Texture2D
	return _preview_texture


func is_empty() -> bool:
	return prop_data == null


func disable() -> void:
	is_locked = false
	is_disabled = true
	_disable_hover()
	$TextureRect2.modulate.a = 0.0
	$TextureRect.modulate.a = 0.0


func enable() -> void:
	is_locked = false
	is_disabled = false
	_disable_hover()
	$TextureRect2.modulate.a = DEFAULT_ALPHA
	$TextureRect.modulate = Color.WHITE


func lock() -> void:
	is_locked = true
	is_disabled = true
	_disable_hover()
	$TextureRect.modulate = Color(0.16, 0.16, 0.16, 0.92)
	$TextureRect2.modulate.a = 0.0


func play_selection_sound() -> void:
	$blub.play()


func _on_mouse_entered() -> void:
	if is_disabled or prop_data == null:
		return
	_is_hovered = true
	_set_hover_visual(true)
	hover_started.emit(self)


func _on_mouse_exited() -> void:
	if not _is_hovered:
		return
	_is_hovered = false
	_set_hover_visual(false)
	hover_ended.emit(self)


func _on_gui_input(event: InputEvent) -> void:
	if is_disabled or prop_data == null:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		accept_event()
		if is_selected_slot:
			removal_requested.emit(self)
		else:
			selection_requested.emit(self)


func _disable_hover() -> void:
	if _is_hovered:
		_is_hovered = false
		hover_ended.emit(self)
	_kill_hover_tween()
	scale = Vector2.ONE


func _set_hover_visual(hovered: bool) -> void:
	_kill_hover_tween()
	var target_modulate: Color = $TextureRect2.modulate
	target_modulate.a = 0.0 if hovered else DEFAULT_ALPHA
	_hover_tween = create_tween()
	_hover_tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_hover_tween.tween_property(self, "scale", HOVER_SCALE if hovered else Vector2.ONE, HOVER_DURATION)
	_hover_tween.parallel().tween_property($TextureRect2, "modulate", target_modulate, HOVER_DURATION)


func _kill_hover_tween() -> void:
	if _hover_tween != null:
		_hover_tween.kill()
		_hover_tween = null

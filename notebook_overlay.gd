extends CanvasLayer

const NOTEBOOK_TEXTURE := preload("res://images/ui/notebook paint fx.png")
const FONT := preload("res://fonts/Laila-Bold.ttf")
const OPEN_POSITION := Vector2(460, 20)
const CLOSED_POSITION := Vector2(460, 1120)
const NOTEBOOK_SCALE := Vector2(1.12, 1.12)
const ACCEPT_COLOR := Color(0.78, 0.92, 0.78, 0.60)
const REJECT_COLOR := Color(0.96, 0.78, 0.78, 0.60)

var is_open := false
var _notebook: Control
var _history_list: VBoxContainer
var _portrait: TextureRect
var _customer_name: Label
var _empty_label: Label
var _toggle_button: Button
var _dimmer: ColorRect
var _tween: Tween

func _ready() -> void:
	add_to_group("notebook_overlay")
	_build_interface()
	refresh()

func _build_interface() -> void:
	var screen := Control.new()
	screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	screen.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(screen)

	_dimmer = ColorRect.new()
	_dimmer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_dimmer.color = Color(0.08, 0.05, 0.03, 0.45)
	_dimmer.modulate.a = 0.0
	_dimmer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_dimmer.gui_input.connect(_on_dimmer_input)
	screen.add_child(_dimmer)

	_notebook = Control.new()
	_notebook.position = CLOSED_POSITION
	_notebook.size = Vector2(760, 930)
	_notebook.scale = NOTEBOOK_SCALE
	_notebook.mouse_filter = Control.MOUSE_FILTER_STOP
	screen.add_child(_notebook)

	var background := TextureRect.new()
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.texture = NOTEBOOK_TEXTURE
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_notebook.add_child(background)

	_portrait = TextureRect.new()
	_portrait.position = Vector2(158, 105)
	_portrait.size = Vector2(118, 135)
	_portrait.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_portrait.flip_h = true
	_portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_notebook.add_child(_portrait)

	_customer_name = Label.new()
	_customer_name.position = Vector2(295, 135)
	_customer_name.size = Vector2(330, 70)
	_customer_name.add_theme_font_override("font", FONT)
	_customer_name.add_theme_font_size_override("font_size", 30)
	_customer_name.add_theme_color_override("font_color", Color(0.22, 0.16, 0.1))
	_customer_name.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_notebook.add_child(_customer_name)

	var scroll := ScrollContainer.new()
	scroll.position = Vector2(148, 270)
	# Four rows (4 * 126px) plus three 14px gaps fit exactly.
	scroll.size = Vector2(505, 550)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_notebook.add_child(scroll)

	_history_list = VBoxContainer.new()
	_history_list.custom_minimum_size = Vector2(485, 0)
	_history_list.add_theme_constant_override("separation", 14)
	scroll.add_child(_history_list)

	_empty_label = Label.new()
	_empty_label.text = "No teas served yet."
	_empty_label.custom_minimum_size = Vector2(485, 90)
	_empty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_empty_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_empty_label.add_theme_font_override("font", FONT)
	_empty_label.add_theme_font_size_override("font_size", 24)
	_empty_label.add_theme_color_override("font_color", Color(0.32, 0.25, 0.17))
	_history_list.add_child(_empty_label)

	_toggle_button = Button.new()
	# Keep the notes control paired with the customer dialogue in the tea-making scene.
	_toggle_button.position = Vector2(94, 650)
	_toggle_button.size = Vector2(346, 62)
	_toggle_button.text = "Open notes"
	_toggle_button.focus_mode = Control.FOCUS_NONE
	_toggle_button.add_theme_font_override("font", FONT)
	_toggle_button.add_theme_font_size_override("font_size", 24)
	_toggle_button.pressed.connect(toggle)
	screen.add_child(_toggle_button)

func toggle() -> void:
	if _tween != null:
		_tween.kill()
	is_open = not is_open
	UiSounds.play_paper(is_open)
	if is_open:
		refresh()
		var preview := get_parent().get_node_or_null("CurrentSelectedProp")
		if preview != null:
			preview.texture = null
		_dimmer.mouse_filter = Control.MOUSE_FILTER_STOP
		_toggle_button.text = "Close notes"
	else:
		_dimmer.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_toggle_button.text = "Open notes"

	_tween = create_tween().set_parallel(true)
	_tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_tween.tween_property(_notebook, "position", OPEN_POSITION if is_open else CLOSED_POSITION, 0.42)
	_tween.tween_property(_dimmer, "modulate:a", 1.0 if is_open else 0.0, 0.32)

func refresh() -> void:
	if _history_list == null:
		return
	var customer := CustomerDatabase.get_current_customer()
	if customer == null:
		_portrait.texture = null
		_customer_name.text = ""
		_clear_history_rows()
		_empty_label.visible = true
		return

	_portrait.texture = load(customer.customerImage)
	_customer_name.text = customer.customerName
	_clear_history_rows()
	_empty_label.visible = customer.tea_history.is_empty()
	for attempt in customer.tea_history:
		_history_list.add_child(_create_history_row(attempt))

func _clear_history_rows() -> void:
	for child in _history_list.get_children():
		if child != _empty_label:
			child.queue_free()

func _create_history_row(attempt: Dictionary) -> PanelContainer:
	var row := PanelContainer.new()
	row.custom_minimum_size = Vector2(485, 126)
	var style := StyleBoxFlat.new()
	style.bg_color = ACCEPT_COLOR if attempt.get("successful", false) else REJECT_COLOR
	style.corner_radius_top_left = 14
	style.corner_radius_top_right = 14
	style.corner_radius_bottom_left = 14
	style.corner_radius_bottom_right = 14
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	row.add_theme_stylebox_override("panel", style)

	var ingredients := HBoxContainer.new()
	ingredients.alignment = BoxContainer.ALIGNMENT_CENTER
	ingredients.add_theme_constant_override("separation", 16)
	row.add_child(ingredients)
	for icon_path in attempt.get("ingredients", []):
		var icon := TextureRect.new()
		icon.custom_minimum_size = Vector2(105, 105)
		icon.texture = load(icon_path)
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		ingredients.add_child(icon)

	var result_mark := Label.new()
	result_mark.custom_minimum_size = Vector2(60, 105)
	result_mark.text = "✓" if attempt.get("successful", false) else "✕"
	result_mark.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	result_mark.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	result_mark.add_theme_font_override("font", FONT)
	result_mark.add_theme_font_size_override("font_size", 68)
	result_mark.add_theme_color_override(
		"font_color",
		Color(0.20, 0.62, 0.28) if attempt.get("successful", false) else Color(0.78, 0.20, 0.20)
	)
	result_mark.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ingredients.add_child(result_mark)
	return row

func _on_dimmer_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		toggle()

func _unhandled_input(event: InputEvent) -> void:
	if is_open and event.is_action_pressed("ui_cancel"):
		toggle()
		get_viewport().set_input_as_handled()

extends Node

@onready var leaderboard_panel = $UI/GameOverMenu/LeaderboardPanel
@onready var scores_container = $UI/GameOverMenu/LeaderboardPanel/MarginContainer/ScoresContainer

@onready var pause_menu = $UI/PauseMenu
@onready var settings_menu = $UI/SettingsMenu
@onready var game_over_menu = $UI/GameOverMenu

@onready var game_over_panel = $UI/GameOverMenu/Panel
@onready var game_over_vbox = $UI/GameOverMenu/Panel/VBoxContainer

@onready var game_over_label = $UI/GameOverMenu/Panel/VBoxContainer/GameOverLabel
@onready var score_label = $UI/GameOverMenu/Panel/VBoxContainer/ScoreLabel
@onready var name_input = $UI/GameOverMenu/Panel/VBoxContainer/NameInput
@onready var save_button = $UI/GameOverMenu/Panel/VBoxContainer/SaveScoreButton
@onready var restart_button = $UI/GameOverMenu/Panel/VBoxContainer/RestartButton
@onready var exit_button = $UI/GameOverMenu/ExitButton

@onready var fade_layer = $UI/FadeLayer


const TEX_GAME_OVER = preload("res://Art/icons/ikony menu/2/GAMEOVER.png")
const TEX_SCORE_BG = preload("res://Art/icons/ikony menu/2/TLO_WYNIK_I_ZAPISZ_NICK.png")
const TEX_RESTART = preload("res://Art/icons/ikony menu/2/RESTART.png")
const TEX_RESTART_PRESSED = preload("res://Art/icons/ikony menu/2/RESTART OC.png")

const FONT_PRESS_START = preload("res://Art/icons/ikony menu/2/PressStart2P-Regular.ttf")


# ROZMIARY ELEMENTÓW 
const SIZE_GAME_OVER := Vector2(560, 135)
const SIZE_STANDARD := Vector2(340, 72)
const GAME_OVER_VBOX_SEPARATION := 4


var score_saved := false
var last_score := 0
var last_player_name := ""
var last_player_rank := -1

var score_box: Control
var name_box: Control

var tutorial_canvas: CanvasLayer
var tutorial_panel: Panel
var tutorial_label: Label
var tutorial_visible := true

var start_fade_canvas: CanvasLayer
var start_fade_layer: ColorRect


func _ready():
	fade_layer.color.a = 0.0
	fade_layer.visible = false

	print("Wybrana postać to: " + GameData.wybrana_postac)

	pause_menu.resume_pressed.connect(_resume_game)
	pause_menu.settings_pressed.connect(_open_settings)
	pause_menu.back_pressed.connect(_close_settings)
	settings_menu.back_pressed.connect(_close_settings)

	game_over_menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	pause_menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	settings_menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	name_input.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	save_button.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	restart_button.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	exit_button.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	name_input.gui_input.connect(_on_name_input_gui_input)

	if restart_button.has_signal("pressed") and not restart_button.pressed.is_connected(_on_restart_button_pressed):
		restart_button.pressed.connect(_on_restart_button_pressed)

	if exit_button.has_signal("pressed") and not exit_button.pressed.is_connected(_on_exit_button_pressed):
		exit_button.pressed.connect(_on_exit_button_pressed)

	_setup_game_over_layout()
	_create_start_fade()
	_create_tutorial()
	_play_start_fade_in()

	if not get_viewport().size_changed.is_connected(_on_viewport_size_changed):
		get_viewport().size_changed.connect(_on_viewport_size_changed)


# ================= FADE IN NA START =================

func _create_start_fade():
	start_fade_canvas = CanvasLayer.new()
	start_fade_canvas.name = "StartFadeCanvas"
	start_fade_canvas.layer = 100
	add_child(start_fade_canvas)

	start_fade_layer = ColorRect.new()
	start_fade_layer.name = "StartFadeLayer"
	start_fade_layer.color = Color(0, 0, 0, 1.0)
	start_fade_canvas.add_child(start_fade_layer)

	start_fade_layer.position = Vector2.ZERO
	start_fade_layer.size = get_viewport().get_visible_rect().size
	start_fade_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _play_start_fade_in():
	var tween = create_tween()
	tween.tween_property(start_fade_layer, "color:a", 0.0, 0.8)

	await tween.finished

	if start_fade_canvas:
		start_fade_canvas.queue_free()


# ================= TUTORIAL =================

func _create_tutorial():
	tutorial_canvas = CanvasLayer.new()
	tutorial_canvas.name = "TutorialCanvas"
	tutorial_canvas.layer = 50
	add_child(tutorial_canvas)

	tutorial_panel = Panel.new()
	tutorial_panel.name = "TutorialPanel"
	tutorial_canvas.add_child(tutorial_panel)

	tutorial_panel.custom_minimum_size = Vector2(900, 370)
	tutorial_panel.size = Vector2(900, 370)
	tutorial_panel.position = (get_viewport().get_visible_rect().size - tutorial_panel.size) / 2.0
	tutorial_panel.mouse_filter = Control.MOUSE_FILTER_STOP

	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0, 0, 0, 0.78)
	panel_style.border_color = Color.WHITE
	panel_style.border_width_left = 3
	panel_style.border_width_right = 3
	panel_style.border_width_top = 3
	panel_style.border_width_bottom = 3
	panel_style.corner_radius_top_left = 12
	panel_style.corner_radius_top_right = 12
	panel_style.corner_radius_bottom_left = 12
	panel_style.corner_radius_bottom_right = 12

	tutorial_panel.add_theme_stylebox_override("panel", panel_style)

	tutorial_label = Label.new()
	tutorial_label.name = "TutorialLabel"
	tutorial_panel.add_child(tutorial_label)

	tutorial_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	tutorial_label.offset_left = 35
	tutorial_label.offset_right = -35
	tutorial_label.offset_top = 25
	tutorial_label.offset_bottom = -25

	tutorial_label.text = "Press WSAD to move your character\n\nPress E to grab equipment from the table\n\npress SHIFT to sprint\n\nGo to the customer with required item\nand press E three times to gain points\n\nPress any button to continue"

	tutorial_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tutorial_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	tutorial_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	tutorial_label.mouse_filter = Control.MOUSE_FILTER_IGNORE

	tutorial_label.add_theme_font_override("font", FONT_PRESS_START)
	tutorial_label.add_theme_font_size_override("font_size", 13)
	tutorial_label.add_theme_color_override("font_color", Color.WHITE)

	tutorial_panel.visible = true
	tutorial_visible = true


func _hide_tutorial():
	if not tutorial_visible:
		return

	tutorial_visible = false

	if tutorial_panel:
		tutorial_panel.visible = false


func _input(event):
	if not tutorial_visible:
		return

	if event is InputEventKey and event.pressed and not event.echo:
		_hide_tutorial()
		get_viewport().set_input_as_handled()

	elif event is InputEventMouseButton and event.pressed:
		_hide_tutorial()
		get_viewport().set_input_as_handled()

	elif event is InputEventJoypadButton and event.pressed:
		_hide_tutorial()
		get_viewport().set_input_as_handled()


func _on_viewport_size_changed():
	if tutorial_panel and tutorial_visible:
		tutorial_panel.position = (get_viewport().get_visible_rect().size - tutorial_panel.size) / 2.0

	if start_fade_layer:
		start_fade_layer.size = get_viewport().get_visible_rect().size


# ================= GAME OVER LAYOUT =================

func _setup_game_over_layout():
	# Lewy panel Game Over

	game_over_panel.set_anchors_preset(Control.PRESET_TOP_LEFT)
	game_over_panel.position = Vector2(80, 90)
	game_over_panel.size = Vector2(640, 800)
	game_over_panel.custom_minimum_size = Vector2(640, 800)

	game_over_vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	game_over_vbox.offset_left = 0
	game_over_vbox.offset_top = 0
	game_over_vbox.offset_right = 0
	game_over_vbox.offset_bottom = 0
	game_over_vbox.alignment = BoxContainer.ALIGNMENT_BEGIN

	game_over_vbox.add_theme_constant_override("separation", GAME_OVER_VBOX_SEPARATION)

	game_over_label.visible = false

	_create_game_over_graphic()
	_create_score_graphic_box()
	_create_name_input_graphic_box()
	_setup_restart_button()

	save_button.visible = false
	save_button.disabled = true


func _apply_vbox_size_settings(control: Control, wanted_size: Vector2):
	control.custom_minimum_size = wanted_size
	control.size = wanted_size
	control.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	control.size_flags_vertical = Control.SIZE_SHRINK_CENTER


func _create_game_over_graphic():
	var game_over_image := game_over_vbox.get_node_or_null("GameOverImage") as TextureRect

	if game_over_image == null:
		game_over_image = TextureRect.new()
		game_over_image.name = "GameOverImage"
		game_over_vbox.add_child(game_over_image)
		game_over_vbox.move_child(game_over_image, 0)

	game_over_image.texture = TEX_GAME_OVER

	_apply_vbox_size_settings(game_over_image, SIZE_GAME_OVER)

	game_over_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	game_over_image.stretch_mode = TextureRect.STRETCH_SCALE
	game_over_image.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _create_score_graphic_box():
	_apply_vbox_size_settings(score_label, SIZE_STANDARD)

	score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	score_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	score_label.add_theme_font_override("font", FONT_PRESS_START)
	score_label.add_theme_font_size_override("font_size", 13)

	score_label.add_theme_color_override("font_color", Color.BLACK)

	var score_style := StyleBoxTexture.new()
	score_style.texture = TEX_SCORE_BG

	score_style.content_margin_left = 35
	score_style.content_margin_right = 35
	score_style.content_margin_top = 12
	score_style.content_margin_bottom = 12

	score_label.add_theme_stylebox_override("normal", score_style)


func _create_name_input_graphic_box():
	_apply_vbox_size_settings(name_input, SIZE_STANDARD)

	name_input.placeholder_text = "WPISZ NICK"
	name_input.alignment = HORIZONTAL_ALIGNMENT_CENTER

	name_input.add_theme_font_override("font", FONT_PRESS_START)
	name_input.add_theme_font_size_override("font_size", 11)

	name_input.add_theme_color_override("font_color", Color.BLACK)
	name_input.add_theme_color_override("font_placeholder_color", Color(0, 0, 0, 0.65))
	name_input.add_theme_color_override("caret_color", Color.BLACK)

	var name_style := StyleBoxTexture.new()
	name_style.texture = TEX_SCORE_BG

	name_style.content_margin_left = 35
	name_style.content_margin_right = 35
	name_style.content_margin_top = 12
	name_style.content_margin_bottom = 12

	name_input.add_theme_stylebox_override("normal", name_style)
	name_input.add_theme_stylebox_override("focus", name_style)
	name_input.add_theme_stylebox_override("read_only", name_style)


func _setup_restart_button():
	_apply_vbox_size_settings(restart_button, SIZE_STANDARD)

	if restart_button is TextureButton:
		restart_button.texture_normal = TEX_RESTART
		restart_button.texture_pressed = TEX_RESTART_PRESSED
		restart_button.texture_hover = TEX_RESTART

		restart_button.ignore_texture_size = true
		restart_button.stretch_mode = TextureButton.STRETCH_SCALE

	elif restart_button is Button:
		restart_button.text = ""
		restart_button.icon = TEX_RESTART
		restart_button.expand_icon = true


func _unhandled_input(event):
	if game_over_menu.visible:
		return

	if event.is_action_pressed("ui_cancel"):
		if settings_menu.visible:
			_close_settings()
			return

		if pause_menu.visible:
			_resume_game()
			return

		_open_pause()


func _open_pause():
	get_tree().paused = true
	pause_menu.visible = true
	settings_menu.visible = false


# ================= GAME OVER =================

func show_game_over(score):
	last_score = score
	score_saved = false
	last_player_name = ""
	last_player_rank = -1

	score_label.text = "WYNIK: " + str(score)

	game_over_menu.visible = true
	leaderboard_panel.visible = true

	name_input.visible = true
	name_input.editable = true
	name_input.text = ""
	name_input.grab_focus()

	save_button.visible = false
	save_button.disabled = true

	_hide_tutorial()

	show_leaderboard()

	fade_layer.color.a = 0.0
	fade_layer.visible = true

	var t = create_tween()
	t.tween_property(fade_layer, "color:a", 1.0, 1.0)

	await t.finished

	get_tree().paused = true


func _on_name_input_gui_input(event):
	if not game_over_menu.visible:
		return

	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			name_input.accept_event()
			_save_score_from_input()


func _save_score_from_input():
	if score_saved:
		return

	score_saved = true

	var player_name = name_input.text.strip_edges()

	if player_name == "":
		player_name = "Anon"

	last_player_name = player_name

	LeaderboardManager.add_score(player_name, last_score)

	last_player_rank = _find_player_rank(player_name, last_score)

	name_input.visible = false

	show_leaderboard()
	leaderboard_panel.visible = true


func _find_player_rank(player_name: String, player_score: int) -> int:
	for i in range(LeaderboardManager.scores.size()):
		var entry = LeaderboardManager.scores[i]

		if entry["name"] == player_name and entry["score"] == player_score:
			return i + 1

	return -1


# ================= ANIMACJA TABELI =================

func animate_leaderboard_row(row: Control, delay: float):
	row.modulate.a = 0.0
	row.scale = Vector2(0.92, 0.92)

	var t = create_tween()
	t.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	t.set_trans(Tween.TRANS_BACK)
	t.set_ease(Tween.EASE_OUT)

	t.tween_interval(delay)
	t.tween_property(row, "modulate:a", 1.0, 0.25)
	t.parallel().tween_property(row, "scale", Vector2.ONE, 0.25)


# ================= PAUSE =================

func _open_settings():
	pause_menu.visible = false
	settings_menu.visible = true


func _close_settings():
	settings_menu.visible = false
	pause_menu.visible = true


func _resume_game():
	get_tree().paused = false
	pause_menu.visible = false
	settings_menu.visible = false


func _on_back_button_pressed():
	_close_settings()
	AudioManager.play_sfx("res://sounds/buttonpress.wav")


# ================= RESTART / EXIT =================

func _on_restart_button_pressed():
	GameManager.reset_game()
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_exit_button_pressed():
	get_tree().quit()


# ================= LEADERBOARD =================

func show_leaderboard():
	for child in scores_container.get_children():
		child.queue_free()

	scores_container.add_theme_constant_override("separation", 10)

	var scores = LeaderboardManager.scores
	var max_scores = min(10, scores.size())

	var delay := 0.0

	for i in range(max_scores):
		var entry = scores[i]

		var row = HBoxContainer.new()
		row.add_theme_constant_override("separation", 45)
		row.custom_minimum_size.y = 34

		var rank = Label.new()
		rank.text = str(i + 1) + "."
		rank.custom_minimum_size.x = 70
		rank.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		rank.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

		var player_name_label = Label.new()
		player_name_label.text = entry["name"]
		player_name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		player_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		player_name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

		var score_value_label = Label.new()
		score_value_label.text = str(entry["score"]) + " pkt"
		score_value_label.custom_minimum_size.x = 165
		score_value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		score_value_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

		for l in [rank, player_name_label, score_value_label]:
			l.add_theme_font_override("font", FONT_PRESS_START)
			l.add_theme_font_size_override("font_size", 21)

		if i == 0:
			for l in [rank, player_name_label, score_value_label]:
				l.add_theme_color_override("font_color", Color.GOLD)

		elif i == 1:
			for l in [rank, player_name_label, score_value_label]:
				l.add_theme_color_override("font_color", Color.SILVER)

		elif i == 2:
			for l in [rank, player_name_label, score_value_label]:
				l.add_theme_color_override("font_color", Color(0.8, 0.5, 0.2))

		else:
			for l in [rank, player_name_label, score_value_label]:
				l.add_theme_color_override("font_color", Color.WHITE)

		if score_saved and i + 1 == last_player_rank:
			for l in [rank, player_name_label, score_value_label]:
				l.add_theme_color_override("font_color", Color.CYAN)
				l.add_theme_font_size_override("font_size", 23)

		row.add_child(rank)
		row.add_child(player_name_label)
		row.add_child(score_value_label)

		scores_container.add_child(row)

		animate_leaderboard_row(row, delay)
		delay += 0.08

	if score_saved and last_player_rank > 10:
		var dots = Label.new()
		dots.text = "..."
		dots.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		dots.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		dots.custom_minimum_size.y = 34
		dots.add_theme_font_override("font", FONT_PRESS_START)
		dots.add_theme_font_size_override("font_size", 21)
		dots.add_theme_color_override("font_color", Color.WHITE)

		scores_container.add_child(dots)

		animate_leaderboard_row(dots, delay)
		delay += 0.08

		var player_row = HBoxContainer.new()
		player_row.add_theme_constant_override("separation", 45)
		player_row.custom_minimum_size.y = 34

		var rank = Label.new()
		rank.text = str(last_player_rank) + "."
		rank.custom_minimum_size.x = 70
		rank.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		rank.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

		var player_name_label = Label.new()
		player_name_label.text = last_player_name
		player_name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		player_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		player_name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

		var score_value_label = Label.new()
		score_value_label.text = str(last_score) + " pkt"
		score_value_label.custom_minimum_size.x = 165
		score_value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		score_value_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

		for l in [rank, player_name_label, score_value_label]:
			l.add_theme_font_override("font", FONT_PRESS_START)
			l.add_theme_font_size_override("font_size", 23)
			l.add_theme_color_override("font_color", Color.CYAN)

		player_row.add_child(rank)
		player_row.add_child(player_name_label)
		player_row.add_child(score_value_label)

		scores_container.add_child(player_row)

		animate_leaderboard_row(player_row, delay)

extends CanvasLayer

@onready var dart_labels = [
	$Panel/VBoxContainer/Dart1Label,
	$Panel/VBoxContainer/Dart2Label,
	$Panel/VBoxContainer/Dart3Label
]
@onready var total_label  = $Panel/TotalLabel
@onready var title_label  = $Panel/TitleLabel
@onready var hint_label   = $Panel/HintLabel


var player
var dartboard
var darts_thrown: int = 0
var total_points: int = 0
var round_done: bool = false
var throwing: bool = false  

func open(p, board, board_pos: Vector2):
	player = p
	dartboard = board
	darts_thrown = 0
	total_points = 0
	round_done = false
	throwing = false
	visible = true
	
	$Panel.visible = false

	player.set_physics_process(false)
	
	title_label.text = "🎯 Rzutki!"
	hint_label.text = "[E] Rzuć!"
	total_label.text = "Suma: 0 pkt"
	for label in dart_labels:
		label.text = "- - -"

func throw_dart():
	if throwing:
		return
	
	if round_done:
		close()
		return
	
	if darts_thrown >= 3:
		return
	
	throwing = true
	
	# animacja rzutu - odpali się gdy dodasz throw_down/up/left/right
	var throw_anim = "throw_" + player.last_direction
	if player.animated_sprite.sprite_frames.has_animation(throw_anim):
		player.animated_sprite.play(throw_anim)
		await player.animated_sprite.animation_finished
	else:
		await get_tree().create_timer(0.4).timeout
	

	player.animated_sprite.play("idle_" + player.last_direction)
	
	var result = dartboard.weighted_random()
	dartboard.show_result_icon(result["points"])
	total_points += result["points"]
	dart_labels[darts_thrown].text = "Rzut %d: %d pkt" % [darts_thrown + 1, result["points"]]
	total_label.text = "Suma: %d pkt" % total_points
	darts_thrown += 1
	
	if darts_thrown >= 3:
		round_done = true
		title_label.text = "Wynik: %d pkt! 🎯" % total_points
		hint_label.text = "[E] Zamknij"
	
	throwing = false

func close():
	visible = false
	player.set_physics_process(true)  

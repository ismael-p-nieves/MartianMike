extends Node2D

@onready var player = null
@onready var spawnPoint = $Start
@onready var exit = $Exit
@onready var deathzone = $deathzone
@onready var hud = $UILayer/HUD
@onready var ui_layer = $UILayer

@export var next_level : PackedScene = null
@export var level_time : float

var timer_node : Timer = null
var time_left
var key
var locked_exit : bool

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	player.global_position = spawnPoint.get_spawn_pos()
	
	var traps = get_tree().get_nodes_in_group("traps")
	for trap in traps:
		trap.connect("touched_player", _on_trap_touched_player)
		
	exit.body_entered.connect(_on_exit_body_entered)
	deathzone.body_entered.connect(_on_deathzone_body_entered)
	
	time_left = level_time
	hud.set_time_label(time_left)
	timer_node = Timer.new()
	timer_node.name = "Level Timer"
	timer_node.wait_time = 1
	timer_node.timeout.connect(_on_level_timer_timeout)
	add_child(timer_node)
	timer_node.start()
	
	if exit.locked:
		key = get_tree().get_first_node_in_group("key")
		key.connect("key_obtained", _unlock_exit)
		locked_exit = true
	else:
		locked_exit = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func _on_deathzone_body_entered(body: Node2D) -> void:
	AudioPlayer.play_sfx("hurt")
	reset_player()

func _on_trap_touched_player() -> void:
	AudioPlayer.play_sfx("hurt")
	reset_player()

func reset_player() -> void:
	player.global_position = spawnPoint.get_spawn_pos()
	player.velocity = Vector2.ZERO
	time_left = level_time
	hud.set_time_label(time_left)

func _on_exit_body_entered(body):
	if body is Player && !locked_exit:
		exit.animate()
		player.active = false
		timer_node.stop()
		await get_tree().create_timer(1.5).timeout
		if next_level != null:
			get_tree().change_scene_to_packed(next_level)
		else:
			ui_layer.show_win_screen(true)

func _on_level_timer_timeout():
	time_left -= 1
	hud.set_time_label(time_left)
	if time_left < 0 :
		reset_player()
		
func _unlock_exit():
	locked_exit = false
	exit.unlock()

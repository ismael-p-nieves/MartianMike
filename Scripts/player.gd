extends CharacterBody2D
class_name Player

@onready var animated_sprite = $AnimatedSprite2D
@onready var initial_position : Vector2 = global_position
@onready var jump_sfx = "res://assets/audio/jump.wav"

@export var gravity : float
@export var speed : float
@export var jump_force : float
@export var max_fall_speed : float
@export var coyote_max_buffer : int
@export var bunny_max_buffer : int

var active = true
var coyote_buffer : int
var bunny_buffer : int

func _ready() -> void:
	coyote_buffer = coyote_max_buffer
	bunny_buffer = 0

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("jump") && active:
		if is_on_floor() || coyote_buffer > 0:
			jump(jump_force)
		else:
			bunny_buffer = bunny_max_buffer

	if is_on_floor():
		coyote_buffer = coyote_max_buffer
		
		if bunny_buffer > 0:
			jump(jump_force)
	else:
		coyote_buffer -= 1
		bunny_buffer -= 1
		
		velocity.y += gravity * delta
		if velocity.y > max_fall_speed:
			velocity.y = max_fall_speed
	
	var direction = 0
	if active:
		direction = Input.get_axis("move_left", "move_right")
		
	velocity.x = direction * speed
	move_and_slide()
	
	update_animations(direction)

func update_animations(direction: float) -> void:
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
				
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
			
func jump(force) -> void:
	AudioPlayer.play_sfx("jump")
	velocity.y = -force
	coyote_buffer = 0
	bunny_buffer = 0

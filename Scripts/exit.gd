extends Area2D

@onready var animated_sprite = $AnimatedSprite2D

@export var locked : bool

func _ready() -> void:
	if locked:
		animated_sprite.play("locked")
	else:
		animated_sprite.play("idle")
 
func unlock() -> void:
	if locked:
		locked = false
		animated_sprite.play("idle")

func animate():
	animated_sprite.play("exit")

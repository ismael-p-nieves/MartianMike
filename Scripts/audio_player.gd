extends Node

var hurt = preload("res://assets/audio/hurt.wav")
var jump = preload("res://assets/audio/jump.wav")

func play_sfx(sfx_name: String):
	var asp = AudioStreamPlayer.new()
	asp.name = "SFX"
	
	if sfx_name == "hurt":
		asp.stream = hurt
	elif sfx_name == "jump":
		asp.stream = jump
	else:
		return
		
	add_child(asp)
	asp.play()
	
	await asp.finished
	asp.queue_free()

extends Area2D

signal key_obtained

func _on_body_entered(body: Node2D) -> void:
	key_obtained.emit()
	queue_free()

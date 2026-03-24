extends Area2D

var amount = 10

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.change_money("money", 10)
		queue_free()

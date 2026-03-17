extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	pass


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Knife:
		print("Ow..damage taken")

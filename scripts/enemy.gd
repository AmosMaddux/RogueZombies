extends CharacterBody2D



const SPEED = 300.0
const JUMP_VELOCITY = -400.0

#Child Nodes
@onready var animated_sprite_2d: AnimatedSprite2D = $Visuals/AnimatedSprite2D

func animate_damage():
	animated_sprite_2d.play("damage_idle")
	
func take_damage(damage_amount: int):
	print("Ow! " + self.name + " has taken " + str(damage_amount) + " damage!")
	animate_damage()
	

func _physics_process(delta: float) -> void:
	pass

extends CharacterBody2D


#Vars
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var health = 100

#Child Nodes
@onready var animated_sprite_2d: AnimatedSprite2D = $Visuals/AnimatedSprite2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

#Other Nodes
@onready var player: Player = %Player

func animate_damage():
	animated_sprite_2d.play("damage_idle")
	await animated_sprite_2d.animation_finished
	if health <= 0:
		die()
	
func die():
	animated_sprite_2d.play("die")
	await animated_sprite_2d.animation_finished
	queue_free()
	
func take_damage(damage_amount: int):
	health -= damage_amount
	print("Ow! " + self.name + " has taken " + str(damage_amount) + " damage! Current health: " + str(health))

	animate_damage()
	

func _process(delta: float) -> void:
	nav_agent.target_position = player.global_position
	nav_agent.get_next_path_position()
	
func _physics_process(delta: float) -> void:
	move_and_slide()

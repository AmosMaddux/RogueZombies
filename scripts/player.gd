extends CharacterBody2D

class_name Player

#Children
@onready var visuals: Node2D = $Visuals
@onready var animated_sprite: AnimatedSprite2D = $Visuals/AnimatedSprite2D
@onready var weapon_pivot: Node2D = $WeaponPivot
@onready var weapon_slot: Marker2D = $WeaponPivot/WeaponSlot

#Health Vars
var health := 100

#Movement Vars
const SPEED = 150.0
const JUMP_VELOCITY = -400.0

#Weapon Vars
var has_knife := false
var knife_equipped := false

func take_damage(damage_amount: int):
	health -= damage_amount
	print("Player has taken damage! Health: " + str(health))
	
func equip_knife():
	if not has_knife:
		has_knife = true
	knife_equipped = true

func rotate_weapon_pivot():
	#Get mouse position relative to the player location
	var mouse_pos = get_global_mouse_position()
	
	#Make the weapon pivot rotate towards the mouse
	weapon_pivot.look_at(mouse_pos)
	
	#Flip weapon based on side
	weapon_pivot.scale.y = 1 if mouse_pos.x > position.x else -1
	
func move():
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	if direction:
		velocity = direction * SPEED
		
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
		
	#Set Animations
	if direction.x != 0:
		animated_sprite.animation = "walk_right" if (direction.x > 0) else "walk_left"
		visuals.scale.x = 1 if (direction.x > 0) else -1
	elif direction.y != 0:
		animated_sprite.animation = "walk_up" if direction.y > 0 else "walk_down"
		visuals.scale.x = 1
		
	
	if direction != Vector2.ZERO:
		animated_sprite.play()
	else:
		animated_sprite.stop()
		animated_sprite.frame = 0

	
	move_and_slide()
	
func attack():
	var current_weapon = weapon_slot.get_child(0) if weapon_pivot.get_child_count() > 0 else null
	
	#TODO: I may not need this if statement after all
	if current_weapon is Knife:
		current_weapon.attack(weapon_slot)
		
	
		
func _process(delta: float) -> void:
	rotate_weapon_pivot()
	
	if Input.is_action_just_pressed("attack"):
		attack()
	

func _physics_process(delta: float) -> void:
	move()

extends CharacterBody2D

class_name Player

#Children
@onready var visuals: Node2D = $Visuals
@onready var animated_sprite: AnimatedSprite2D = $Visuals/AnimatedSprite2D
@onready var weapon_pivot: Node2D = $WeaponPivot
@onready var weapon_slot: Marker2D = $WeaponPivot/WeaponSlot

#Health Vars
var health := 100
var is_alive := true

#Movement Vars
const SPEED = 150.0
const JUMP_VELOCITY = -400.0

#Weapon Vars
var has_knife := false
var knife_equipped := false
var has_pistol := false
var pistol_equipped := false
var has_shotgun := false
var shotgun_equipped := false

func take_damage(damage_amount: int):
	health -= damage_amount
	print("Player has taken damage! Health: " + str(health))
	
	#Flash red
	var tween = create_tween()
	tween.tween_property(animated_sprite, "self_modulate", Color.RED, 0.1)
	tween.tween_property(animated_sprite, "self_modulate", Color.WHITE, 0.1)

	
	if health <= 0:
		GameEvents.player_health_changed.emit(0)
		is_alive = false
		die()
	else:
		GameEvents.player_health_changed.emit(health)
		
func die():
	Engine.time_scale = 0.5
	animated_sprite.play("die")
	await animated_sprite.animation_finished
	queue_free()
	
func equip_knife():
	if not has_knife:
		has_knife = true
	knife_equipped = true
	
func equip_pistol():
	if not has_pistol:
		has_pistol = true
	pistol_equipped = true
	
func equip_shotgun():
	if not has_shotgun:
		has_shotgun = true
	shotgun_equipped = true

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
	#Call the weapon's attack function
	var current_weapon = weapon_slot.get_child(0) if weapon_pivot.get_child_count() > 0 else null
	if current_weapon != null:
		current_weapon.attack(weapon_slot)
		
func reload_weapon():
	#If weapon is not knife
	var current_weapon = weapon_slot.get_child(0) if weapon_pivot.get_child_count() > 0 else null
	if current_weapon != null and current_weapon is not Knife:
		current_weapon.reload()

func _ready() -> void:
	#Initialize UI
	await get_tree().process_frame
	GameEvents.player_health_changed.emit(health)
		
func _process(delta: float) -> void:
	if is_alive:
		rotate_weapon_pivot()
	
		if Input.is_action_just_pressed("attack"):
			attack()
			
		if Input.is_action_just_pressed("reload"):
			reload_weapon()
	

func _physics_process(delta: float) -> void:
	if is_alive:
		move()

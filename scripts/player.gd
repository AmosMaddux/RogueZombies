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
var is_weapon_equipped := false
@export var held_weapons: Array[PackedScene] = []
var current_weapon_index := 0
var current_weapon: Area2D = null

var has_knife := false
var knife_equipped := false
var has_pistol := false
var pistol_equipped := false
var has_shotgun := false
var shotgun_equipped := false

@export var shotgun_scene: PackedScene


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
	
func equip_weapon(index: int):
	#Get rid of old weapon
	if current_weapon:
		current_weapon.queue_free()
		
	#Create new weapon and add to Weapon slot
	var new_weapon = held_weapons[index].instantiate()
	weapon_slot.add_child(new_weapon)
	current_weapon = new_weapon
	
func collect_weapon(name):
	#Add weapon to list
	if name == "Shotgun":
		held_weapons.append(shotgun_scene)
	
	#Automatically Equip
	current_weapon_index = held_weapons.size() - 1
	print("Held Weapons: " + str(held_weapons.size()))
	print("Weapon_index: " + str(current_weapon_index))
	equip_weapon(current_weapon_index)
	
func cycle_weapon(direction: int):
	#Use mod to handle wrapping around
	current_weapon_index = (current_weapon_index + direction) % held_weapons.size()
	#Must reset if wraps around backwards
	if current_weapon_index < 0:
		current_weapon_index = held_weapons.size() - 1
		
	equip_weapon(current_weapon_index)
		
func switch_weapon():
	#Only cycle if more than one weapon is held
	if held_weapons.size() > 2:
		if Input.is_action_just_pressed("next_weapon"):
			cycle_weapon(1)
		elif Input.is_action_just_pressed("previous_weapon"):
			cycle_weapon(-1)
			

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
	if Input.is_action_just_pressed("attack"):
		#Call the weapon's attack function
		var current_weapon = weapon_slot.get_child(0) if weapon_pivot.get_child_count() > 0 else null
		if current_weapon != null:
			current_weapon.attack(weapon_slot)
		
func reload_weapon():
	if Input.is_action_just_pressed("reload"):
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
		
		#Input actions
		switch_weapon()
		attack()
		reload_weapon()
	

func _physics_process(delta: float) -> void:
	if is_alive:
		move()

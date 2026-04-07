extends CharacterBody2D


#Vars
#Movement vars
var min_speed := 10
var max_speed := 30
var speed = 30
const JUMP_VELOCITY = -400.0

#Health Vars
var health = 100
var is_stunned := false
var is_alive = true

#Attack Vars
var is_attacking := false
var min_attack_distance := 150
var distance_to_player := 0.0

#Child Nodes
@onready var animated_sprite_2d: AnimatedSprite2D = $Visuals/AnimatedSprite2D
@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var vomit_origin: Marker2D = $Visuals/VomitOrigin
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

#Other Nodes
@onready var player: Player
@onready var visuals: Node2D = $Visuals
@export var money_scene: PackedScene

#PackedScenes
@export var vomit_projectile: PackedScene 

#SFX
@export var hit_grunt: AudioStream
@export var attack_grunt: AudioStream

func _ready() -> void:
	speed = randf_range(min_speed, max_speed)
	player = get_tree().get_first_node_in_group("player")

	
func _physics_process(delta: float) -> void:
	if not is_stunned and is_alive:
		#Check if close enough to attack
		distance_to_player = global_position.distance_to(player.global_position)
		if not is_attacking and (distance_to_player < min_attack_distance):
			start_attack()
		elif not is_attacking:
			move()
			
func animate_damage():
	animated_sprite_2d.play("damage_idle")
	await animated_sprite_2d.animation_finished
	if health <= 0:
		die()
	else:
		is_stunned = false
		
func animate_walk(direction: Vector2):
	#Set animation based on primary direction
	if abs(direction.x) > abs(direction.y):
		animated_sprite_2d.play("walk_left")
		visuals.scale.x = -1 if direction.x > 0 else 1
	else:
		if direction.y > 0: #Walking down
			animated_sprite_2d.play("walk_down")
		else:
			animated_sprite_2d.play("walk_up")
	
func die():
	is_alive = false
	animated_sprite_2d.play("die")
	#Play SFX
	audio_stream_player.stream = hit_grunt
	audio_stream_player.pitch_scale = randf_range(0.8, 1.5)
	audio_stream_player.play()
	await animated_sprite_2d.animation_finished
	
	#Instantiate Money object at location
	var money = money_scene.instantiate()
	money.global_position = self.global_position
	get_tree().root.add_child(money)
	
	queue_free()
	
func take_damage(damage_amount: int):
	is_stunned = true
	health -= damage_amount
	print("Ow! " + self.name + " has taken " + str(damage_amount) + " damage! Current health: " + str(health))

	animate_damage()
	
func move():
	#Set the target position and move toward the next path location
	nav_agent.target_position = player.global_position
	var next_path_pos = nav_agent.get_next_path_position()
	
	#Get direction vector towards path and normalize
	var direction = global_position.direction_to(next_path_pos)
	animate_walk(direction)
	velocity = direction * speed
	move_and_slide()
	
func start_attack():
	#Play SFX
	audio_stream_player.stream = attack_grunt
	audio_stream_player.pitch_scale = randf_range(0.8, 1.5)
	audio_stream_player.play()
	
	is_attacking = true
	var x_direction = -1 if velocity.x > 0 else 1
	velocity = Vector2.ZERO
	var tween = create_tween()
	
	for i in range(3):
		#Bulge scale and flash red
		tween.tween_property(visuals, "scale", Vector2(1.2 * x_direction, 1.2), 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(animated_sprite_2d, "self_modulate", Color.RED, 0.1)
		#Snap back to normal size and color
		tween.tween_property(visuals, "scale", Vector2(1.0 * x_direction, 1.0), 0.05).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(animated_sprite_2d, "self_modulate", Color.WHITE, 0.05)
	
	#Damage player if still close enough
	tween.tween_callback(attack)
	
	#Timeout and reset is_attacking
	tween.tween_callback(func(): animated_sprite_2d.frame = 0)
	tween.tween_interval(1)
	tween.tween_callback(func(): is_attacking = false)
	
func attack():
	if is_alive:
		var vomit = vomit_projectile.instantiate()
		vomit.global_transform = vomit_origin.global_transform
		get_tree().root.add_child(vomit)

func set_vars(health_wave_mod: int):
	health += health_wave_mod

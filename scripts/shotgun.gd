extends Area2D
class_name Shotgun

#Vars
var is_attacking = false
@export var attack_timeout := 0.5


#Child Nodes
@onready var hitbox: CollisionShape2D = $hitbox/CollisionShape2D
@onready var bullet_spawn_point: Marker2D = $BulletSpawnPoint
@onready var cooldown: Timer = $Timer

#Packed Scenes
@export var bullet_scene: PackedScene
@export var fire_fx: PackedScene

var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func attack(origin: Marker2D):
	if cooldown.is_stopped() and player.shotgun_current_ammo > 0:
		
		player.shotgun_current_ammo -= 1
		GameEvents.player_ammo_changed.emit(player.shotgun_current_ammo, player.shotgun_ammo_reserves)
		
		print("You have " + str(player.shotgun_current_ammo) + " ammo")
		#Instantiate 4 bullets and flash
		var spawned_bullets = []
		for i in range(4):
			var bullet := bullet_scene.instantiate()
			spawned_bullets.append(bullet)
			
		var flash := fire_fx.instantiate()
		
		for bullet in spawned_bullets:
			#Must add bullet to main root so it moves independently
			get_tree().root.add_child(bullet)
			#Spawn bullet with random spread
			bullet.global_transform = bullet_spawn_point.global_transform
			var spread = deg_to_rad(45)
			bullet.rotation += randf_range(-spread, spread)
		
		#Add flash to muzzle
		bullet_spawn_point.add_child(flash)
		
		#Start cooldown timer
		cooldown.start()
		
func reload():
	
	while player.shotgun_ammo_reserves > 0 and player.shotgun_current_ammo < 4:
		player.shotgun_current_ammo += 1
		player.shotgun_ammo_reserves -= 1
	GameEvents.player_ammo_changed.emit(player.shotgun_current_ammo, player.shotgun_ammo_reserves)
		

		
func set_up():		
	#Initialize UI
	GameEvents.player_ammo_changed.emit(player.shotgun_current_ammo, player.shotgun_ammo_reserves)

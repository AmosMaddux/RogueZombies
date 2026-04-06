extends Area2D
class_name Pistol

#Vars
var is_attacking = false
@export var attack_timeout := 0.1


#Child Nodes
@onready var hitbox: CollisionShape2D = $hitbox/CollisionShape2D
@onready var bullet_spawn_point: Marker2D = $BulletSpawnPoint
@onready var cooldown: Timer = $Timer
@onready var audio_stream_player_2d: AudioStreamPlayer = $AudioStreamPlayer2D

#Packed Scenes
@export var bullet_scene: PackedScene
@export var fire_fx: PackedScene

var player: Player


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	
	

func attack(origin: Marker2D):
	if cooldown.is_stopped() and player.pistol_current_ammo > 0:
		
		player.pistol_current_ammo -= 1
		GameEvents.player_ammo_changed.emit(player.pistol_current_ammo, player.pistol_ammo_reserves)
		
		#Play SFX
		audio_stream_player_2d.pitch_scale = randf_range(0.7, 1.3)
		audio_stream_player_2d.play()
		
		#Instantiate bullet and flash
		var bullet := bullet_scene.instantiate()
		var flash := fire_fx.instantiate()
		
		#Must add bullet to main root so it moves independently
		get_tree().root.add_child(bullet)
		
		#Add flash to muzzle
		bullet_spawn_point.add_child(flash)
		
		#Sync bullet and flash to muzzle
		bullet.global_transform = bullet_spawn_point.global_transform

		#Start cooldown timer
		cooldown.start()
		
func reload():
	
	while player.pistol_ammo_reserves > 0 and player.pistol_current_ammo < 8:
		player.pistol_ammo_reserves -= 1
		player.pistol_current_ammo += 1
		
	GameEvents.player_ammo_changed.emit(player.pistol_current_ammo, player.pistol_ammo_reserves)

		
func set_up():
	#Initialize UI
	GameEvents.player_ammo_changed.emit(player.pistol_current_ammo, player.pistol_ammo_reserves)

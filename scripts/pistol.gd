extends Area2D
class_name Pistol

#Vars
var is_attacking = false
@export var attack_timeout := 0.1
@export var max_ammo := 8
var current_ammo := 0

#Child Nodes
@onready var hitbox: CollisionShape2D = $hitbox/CollisionShape2D
@onready var bullet_spawn_point: Marker2D = $BulletSpawnPoint
@onready var cooldown: Timer = $Timer

#Packed Scenes
@export var bullet_scene: PackedScene
@export var fire_fx: PackedScene

func _ready() -> void:
	current_ammo = max_ammo
	
	

func attack(origin: Marker2D):
	if cooldown.is_stopped() and current_ammo > 0:
		
		current_ammo -= 1
		GameEvents.player_ammo_changed.emit(current_ammo)
		
		print("You have " + str(current_ammo) + " ammo")
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
	current_ammo = max_ammo
	GameEvents.player_ammo_changed.emit(current_ammo)

		
func equip_to_player(player: CharacterBody2D):
	#Add knife to weapon slot in player and remove from main scene
	var slot = player.get_node("WeaponPivot/WeaponSlot")
	get_parent().remove_child(self)
	slot.add_child(self)
	
	# Set position and rotation local to weapon slot
	position = Vector2.ZERO
	rotation = 0
	
	#Initialize UI
	GameEvents.player_ammo_changed.emit(current_ammo)

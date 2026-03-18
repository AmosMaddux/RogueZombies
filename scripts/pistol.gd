extends Area2D
class_name Pistol

#Vars
var is_equipped = false
var is_attacking = false
@export var attack_timeout := 0.1

#Child Nodes
@onready var hitbox: CollisionShape2D = $hitbox/CollisionShape2D
@onready var bullet_spawn_point: Marker2D = $BulletSpawnPoint
@onready var cooldown: Timer = $Timer

#Packed Scenes
@export var bullet_scene: PackedScene
@export var fire_fx: PackedScene

func attack(origin: Marker2D):
	if cooldown.is_stopped():
		print("Pistol shooting... pew pew!")
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
		
func _on_body_entered(body: Node2D) -> void:
	print("Pistol riggered!")
	if body.is_in_group("player") and not is_equipped:
		print("Player entered")
		equip_to_player(body)
		
func equip_to_player(player: CharacterBody2D):
	is_equipped = true
	player.equip_pistol()
	
	#Disable collision so it doesn't collide while holding
	$CollisionShape2D.set_deferred("disabled", true)
	
	#Add knife to weapon slot in player and remove from main scene
	var slot = player.get_node("WeaponPivot/WeaponSlot")
	get_parent().remove_child(self)
	slot.add_child(self)
	
	# Set position and rotation local to weapon slot
	position = Vector2.ZERO
	rotation = 0

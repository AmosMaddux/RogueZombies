extends Area2D

#Child Nodes
@onready var shotgun_sprite: Sprite2D = $ShotgunSprite
@onready var pistol_sprite: Sprite2D = $PistolSprite
@onready var knife_sprite: Sprite2D = $KnifeSprite

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

#Other Nodes
@onready var player: Player = %Player

#Set up vars
@export var is_knife := false
@export var is_pistol := false
@export var is_shotgun := false

var weapon_name := ""

var is_equipped := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	#Set up the weapon pick up depending on what weapon it is
	if is_knife:
		weapon_name = "Knife"
		knife_sprite.visible = true
	elif is_pistol:
		weapon_name = "Pistol"
		pistol_sprite.visible = true
	elif is_shotgun:
		weapon_name = "Shotgun"
		shotgun_sprite.visible = true

func equip_to_player():
	print("Equipping...")
	player.collect_weapon(weapon_name)
	queue_free()
	
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not is_equipped:
		is_equipped = true
		print("Triggered by player!")
		call_deferred("equip_to_player")

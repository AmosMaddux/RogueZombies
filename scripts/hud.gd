extends CanvasLayer

@onready var health_num: Label = $MarginContainer/Control/ColorRect/HealthNum
@onready var ammo_num: Label = $MarginContainer/Control/ColorRect/AmmoNum
@onready var money_num: Label = $MarginContainer/Control/ColorRect/MoneyNum
@onready var ammo_reserve_num: Label = $MarginContainer/Control/ColorRect/AmmoReserveNum
@onready var weapon_icon: TextureRect = $MarginContainer/Control/ColorRect/WeaponIcon

@export var knife_icon: Texture2D
@export var pistol_icon: Texture2D
@export var shotgun_icon: Texture2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.player_health_changed.connect(on_health_updated)
	GameEvents.player_ammo_changed.connect(on_ammo_updated)
	GameEvents.weapon_changed.connect(on_weapon_name_changed)
	GameEvents.money_changed.connect(on_money_changed)
	
func on_health_updated(new_health):
	health_num.text = str(new_health)

func on_ammo_updated(new_ammo, new_reserves):
	ammo_num.text = str(new_ammo)
	ammo_reserve_num.text = str(new_reserves)
	
func on_weapon_name_changed(new_weapon_name):
	#weapon_name_text.text = new_weapon_name
	if new_weapon_name == "knife":
		weapon_icon.texture = knife_icon
	elif new_weapon_name == "Pistol":
		weapon_icon.texture = pistol_icon
	elif new_weapon_name == "Shotgun":
		weapon_icon.texture = shotgun_icon
	else:
		print("Invalid weapon name. Icon cannot be set!")
	
func on_money_changed(new_money):
	money_num.text = ("$" + str(new_money))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

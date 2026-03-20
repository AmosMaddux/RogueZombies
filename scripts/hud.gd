extends CanvasLayer

@onready var health_num: Label = $MarginContainer/Control/ColorRect/HealthNum
@onready var ammo_num: Label = $MarginContainer/Control/ColorRect/AmmoNum
@onready var weapon_name_text: Label = $MarginContainer/Control/ColorRect/WeaponNameText

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.player_health_changed.connect(on_health_updated)
	GameEvents.player_ammo_changed.connect(on_ammo_updated)
	GameEvents.weapon_changed.connect(on_weapon_name_changed)
		
func on_health_updated(new_health):
	health_num.text = str(new_health)

func on_ammo_updated(new_ammo):
	ammo_num.text = str(new_ammo)
	
func on_weapon_name_changed(new_weapon_name):
	weapon_name_text.text = new_weapon_name
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends CanvasLayer

@onready var health_num: Label = $MarginContainer/Control/ColorRect/HealthNum
@onready var ammo_num: Label = $MarginContainer/Control/ColorRect/AmmoNum

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.player_health_changed.connect(on_health_updated)
	GameEvents.player_ammo_changed.connect(on_ammo_updated)
		
func on_health_updated(new_health):
	health_num.text = str(new_health)

func on_ammo_updated(new_ammo):
	ammo_num.text = str(new_ammo)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

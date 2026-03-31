extends StaticBody2D


#PackedScenes
@export var health_pickup_scene: PackedScene
@export var pistol_ammo_pickup_scene: PackedScene
@export var shotgun_ammo_pickup_scene: PackedScene

@onready var health_pickup_location: Marker2D = $HealthPickupLocation
@onready var pistol_ammo_location: Marker2D = $PistolAmmoLocation
@onready var shotgun_ammo_location: Marker2D = $ShotgunAmmoLocation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.wave_over.connect(restock)
	restock()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func restock():
	#Check if Health Pickup is gone and restock
	var children = health_pickup_location.get_children()
	if children.size() == 0:
		var health_pickup = health_pickup_scene.instantiate()
		health_pickup_location.add_child(health_pickup)
		
	#Check if Pistol Ammo Pickup is gone and restock
	children = pistol_ammo_location.get_children()
	if children.size() == 0:
		var pistol_pickup = pistol_ammo_pickup_scene.instantiate()
		pistol_ammo_location.add_child(pistol_pickup)
		
	#Check if Shotgun Ammo Pickup is gone and restock
	children = shotgun_ammo_location.get_children()
	if children.size() == 0:
		var shotgun_pickup = shotgun_ammo_pickup_scene.instantiate()
		shotgun_ammo_location.add_child(shotgun_pickup)

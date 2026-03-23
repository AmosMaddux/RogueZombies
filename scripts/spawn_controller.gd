extends Node2D

#Child nodes
@onready var spawn_timer: Timer = $SpawnTimer
@onready var wave_timer: Timer = $WaveTimer

#PackedScenes
@export var big_zombie: PackedScene
@export var fast_zombie: PackedScene
@export var turret_zombie: PackedScene

#Other Nodes
@export var spawnpoints_node: Node2D
@export var enemy_container: Node2D

var spawnpoints = []

var zoms_to_spawn = 5
var zoms_spawned = 0

var current_wave = 1
var in_wave = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnpoints = spawnpoints_node.get_children()
	start_wave()
	
	
func start_wave():
	print("Wave starting...")
	#Reset wave Vars
	current_wave += 1
	zoms_spawned = 0
	zoms_to_spawn = ceil(current_wave * 1.5)
	
	#Spawn initial zombie
	spawn_zombie()
	
	#Set in_wave so wave end checker will work
	in_wave = true
	
	#Reset Timers
	spawn_timer.start()
	wave_timer.stop()
	
func stop_wave():
	
	in_wave = false
	
	spawn_timer.stop()
	wave_timer.start()
	
func spawn_zombie():
	if zoms_to_spawn > 0 and in_wave:
		#Get spawnpoint and add enemy to tree
		var spawnpoint = spawnpoints.pick_random().global_position
		var new_enemy = big_zombie.instantiate()
		new_enemy.global_position = spawnpoint
		enemy_container.add_child(new_enemy)
		
		#Change vars
		zoms_to_spawn -= 1
		zoms_spawned += 1
		print("Spawned zombie at " + str(spawnpoint))
		print(str(zoms_to_spawn) + " zombies left in wave")
		
			
func check_if_wave_over():
	if in_wave and zoms_to_spawn <= 0:
		var enemies_left = get_tree().get_nodes_in_group("enemy")
		
		if enemies_left.size() == 0:
			stop_wave()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	check_if_wave_over()
	if not in_wave:
		print("WaveTimer: " + str(wave_timer.time_left))


func _on_spawn_timer_timeout() -> void:
	spawn_zombie()

func _on_wave_timer_timeout() -> void:
	start_wave()
	

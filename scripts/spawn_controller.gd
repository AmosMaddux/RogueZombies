extends Node2D

@export var testing_mode = false

#Child nodes
@onready var spawn_timer: Timer = $SpawnTimer
@onready var wave_timer: Timer = $WaveTimer

#PackedScenes
@export var skinny_zombie: PackedScene
@export var big_zombie: PackedScene
@export var fast_zombie: PackedScene
@export var turret_zombie: PackedScene

#Other Nodes
@export var spawnpoints_node: Node2D
@export var enemy_container: Node2D

var spawnpoints = []

var skinny_zoms_to_spawn = 5
var skinny_zoms_spawned = 0
var big_zoms_to_spawn = 5
var big_zoms_spawned = 0
var fast_zoms_to_spawn = 5
var fast_zoms_spawned = 0
var turret_zoms_to_spawn = 5
var turret_zoms_spawned = 0

var current_wave = 0
var in_wave = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not testing_mode:
		spawnpoints = spawnpoints_node.get_children()
		start_wave()
	
	
func start_wave():
	print("Wave starting...")
	#Reset wave Vars
	current_wave += 1
	GameEvents.new_wave_started.emit(current_wave)
	#Spawn one and a half skinny zombies per wave
	skinny_zoms_spawned = 0
	skinny_zoms_to_spawn = ceil(current_wave * 1.5)
	#Spawn big zombies equal to the current wave, starting at the third wave
	big_zoms_spawned = 0
	big_zoms_to_spawn = ceil(current_wave - 2)
	#Spawn 2 fast zombies for every third level starting on level 6
	fast_zoms_to_spawn = 0
	fast_zoms_to_spawn = ceil((current_wave - 5) / 3 * 2)
	#Spawn 2 turret zombies every fifth level starting on level 10
	turret_zoms_spawned = 0
	turret_zoms_to_spawn = ceil((current_wave -  9)/ 5 * 2)
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
	if in_wave:
		if skinny_zoms_to_spawn > 0:
			#Get spawnpoint 
			var spawnpoint = spawnpoints.pick_random().global_position
			var new_enemy = skinny_zombie.instantiate()
			
			#Add more health to enemy depending on wave
			new_enemy.set_vars((current_wave - 1 ) * 25)
			
			#Spawn enemy at spawn point
			new_enemy.global_position = spawnpoint
			enemy_container.add_child(new_enemy)
			
			#Change vars
			skinny_zoms_to_spawn -= 1
			skinny_zoms_spawned += 1
			print("Spawned zombie at " + str(spawnpoint))
			print(str(skinny_zoms_to_spawn) + " zombies left in wave")
		elif big_zoms_to_spawn > 0:
			#Get spawnpoint 
			var spawnpoint = spawnpoints.pick_random().global_position
			var new_enemy = big_zombie.instantiate()
			
			#Add more health to enemy depending on wave
			new_enemy.set_vars((current_wave - 1 ) * 25)
			
			#Spawn enemy at spawn point
			new_enemy.global_position = spawnpoint
			enemy_container.add_child(new_enemy)
			
			#Change vars
			big_zoms_to_spawn -= 1
			big_zoms_spawned += 1
			print("Spawned zombie at " + str(spawnpoint))
			print(str(big_zoms_to_spawn) + " zombies left in wave")
		elif fast_zoms_to_spawn > 0:
			#Get spawnpoint 
			var spawnpoint = spawnpoints.pick_random().global_position
			var new_enemy = fast_zombie.instantiate()
			
			#Add more health to enemy depending on wave
			new_enemy.set_vars((current_wave - 1 ) * 25)
			
			#Spawn enemy at spawn point
			new_enemy.global_position = spawnpoint
			enemy_container.add_child(new_enemy)
			
			#Change vars
			fast_zoms_to_spawn -= 1
			fast_zoms_spawned += 1
			print("Spawned zombie at " + str(spawnpoint))
			print(str(fast_zoms_to_spawn) + " zombies left in wave")
		elif turret_zoms_to_spawn > 0:
			#Get spawnpoint 
			var spawnpoint = spawnpoints.pick_random().global_position
			var new_enemy = turret_zombie.instantiate()
			
			#Add more health to enemy depending on wave
			new_enemy.set_vars((current_wave - 1 ) * 25)
			
			#Spawn enemy at spawn point
			new_enemy.global_position = spawnpoint
			enemy_container.add_child(new_enemy)
			
			#Change vars
			turret_zoms_to_spawn -= 1
			turret_zoms_spawned += 1
			print("Spawned zombie at " + str(spawnpoint))
			print(str(turret_zoms_to_spawn) + " zombies left in wave")
			
			
func check_if_wave_over():
	#If there are no more zoms to be spawned, and we are currently in a wave, check if all the enemies are deadd
	if in_wave and (big_zoms_to_spawn + skinny_zoms_to_spawn + turret_zoms_to_spawn + fast_zoms_to_spawn) <= 0:
		var enemies_left = get_tree().get_nodes_in_group("enemy")
		
		if enemies_left.size() == 0:
			GameEvents.wave_over.emit()
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
	

extends CharacterBody2D

@onready var visuals = $Visuals
const SPEED = 150.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	if direction:
		velocity = direction * SPEED
		
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)

	
	move_and_slide()

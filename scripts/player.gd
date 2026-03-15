extends CharacterBody2D

@onready var visuals: Node2D = $Visuals
@onready var animated_sprite: AnimatedSprite2D = $Visuals/AnimatedSprite2D

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

# Version Control Test

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	if direction:
		velocity = direction * SPEED
		
	else:
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
		
	#Set Animations
	if direction.x != 0:
		animated_sprite.animation = "walk_right" if (direction.x > 0) else "walk_left"
		visuals.scale.x = 1 if (direction.x > 0) else -1
	elif direction.y != 0:
		animated_sprite.animation = "walk_up" if direction.y > 0 else "walk_down"
		visuals.scale.x = 1
		
	
	if direction != Vector2.ZERO:
		animated_sprite.play()
	else:
		animated_sprite.stop()
		animated_sprite.frame = 0

	
	move_and_slide()

extends Area2D

@export var min_speed = 100
@export var max_speed = 200
var speed = 0
var direction: Vector2
var damage_amount = 20

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	look_at(player.global_position)
	speed = randf_range(min_speed, max_speed)
	direction = global_position.direction_to(player.global_position)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(damage_amount)
		animated_sprite_2d.play("splat")
		await animated_sprite_2d.animation_finished
		queue_free()

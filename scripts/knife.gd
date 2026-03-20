extends Area2D
class_name Knife

#Vars
var targets_hit = []
@export var damage_amount := 50
var is_attacking = false

#Child Nodes
@onready var hitbox: CollisionShape2D = $hitbox/CollisionShape2D


#Packed Scenes
@export var fx_scene: PackedScene

func attack(origin: Marker2D):
		if not is_attacking:
			is_attacking = true
			#Clear targets hit
			targets_hit.clear()
			#Enable hitbox of knife
			hitbox.set_deferred("disabled", false)
			#Tween the knife so it looks like a slash
			var tween = create_tween()
			#Wind up
			tween.tween_property(self, "rotation", deg_to_rad(-45), 0.05)
			tween.parallel().tween_property(self, "position:y", -10.0, 0.05)
			#Slash
			tween.tween_property(self, "rotation", deg_to_rad(45), 0.1).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
			tween.parallel().tween_property(self, "position:y", 5.0, 0.1)
			#Back to normal
			tween.tween_property(self, "rotation", 0, 0.1)
			tween.parallel().tween_property(self, "position:y", 0.0, 0.1)
			#Disable hitbox again
			tween.tween_callback(func(): hitbox.set_deferred("disabled", true))
			#Instantiate scene and add as child
			var fx = fx_scene.instantiate()
			origin.add_child(fx)
			
			#Timeout, then reset is_attacking
			tween.tween_interval(0.1)
			tween.tween_callback(func(): is_attacking = false)

		
func equip_to_player(player: CharacterBody2D):
	#Add knife to weapon slot in player and remove from main scene
	var slot = player.get_node("WeaponPivot/WeaponSlot")
	get_parent().remove_child(self)
	slot.add_child(self)
	
	# Set position and rotation local to weapon slot
	position = Vector2.ZERO
	rotation = 0


func _on_hitbox_body_entered(body: Node2D) -> void:
	#Only apply damage if enemy has not been hit in this attack already
	if body.is_in_group("enemy") and not targets_hit.has(body):
		targets_hit.append(body)
		body.take_damage(damage_amount)

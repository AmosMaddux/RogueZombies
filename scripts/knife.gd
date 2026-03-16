extends Area2D

var is_equipped = false


func _on_body_entered(body: Node2D) -> void:
	print("Triggered!")
	if body.is_in_group("player") and not is_equipped:
		print("Player entered")
		equip_to_player(body)
		
func equip_to_player(player: CharacterBody2D):
	is_equipped = true
	
	#Disable collision so it doesn't collide while holding
	$CollisionShape2D.set_deferred("disabled", true)
	
	#Add knife to weapon slot in player and remove from main scene
	var slot = player.get_node("WeaponPivot/WeaponSlot")
	get_parent().remove_child(self)
	slot.add_child(self)
	
	# Set position and rotation local to weapon slot
	position = Vector2.ZERO
	rotation = 90

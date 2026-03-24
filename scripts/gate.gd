extends Area2D

#Child Nodes
@onready var price_label: Label = $Price
@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D

#Vars
@export var price = 100
var is_player_in_area = false
var gates_purchased = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.gate_purchased.connect(change_price)
	
	price = (gates_purchased * 200) + 100
	price_label.text = ("$" + str(price))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	buy()

func buy():
	if is_player_in_area:
		var player = get_tree().get_first_node_in_group("player")
		if Input.is_action_just_pressed("buy") and player.change_money("gate", price):
			collision_shape_2d.disabled = true
			var nav_region = get_tree().get_first_node_in_group("nav")
			nav_region.bake_navigation_polygon()
			queue_free()
			

func change_price():
	gates_purchased += 1
	price = (gates_purchased * 200) + 100
	price_label.text = ("$" + str(price))
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Player entered!")
		is_player_in_area = true
		price_label.visible = true
		

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Player exited!")
		is_player_in_area = false
		price_label.visible = false

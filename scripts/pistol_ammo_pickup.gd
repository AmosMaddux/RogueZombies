extends Area2D

#Child Nodes
@onready var label: Label = $Label
@onready var price_label: Label = $Label/Price

#Vars
@export var price = 100
var is_player_in_area = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	price_label.text = ("$" + str(price))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	buy()

func buy():
	if is_player_in_area:
		var player = get_tree().get_first_node_in_group("player")
		if Input.is_action_just_pressed("buy") and player.change_money("pistol_ammo", price):
			queue_free()
			
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Player entered!")
		is_player_in_area = true
		label.visible = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Player exited!")
		is_player_in_area = false
		label.visible = false

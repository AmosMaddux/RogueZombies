extends Node

#Player Events
signal player_health_changed(new_health)
signal player_ammo_changed(new_ammo, new_reserves)
signal weapon_changed(weapon_name)
signal money_changed(new_money)

#Gate Events and Functions
signal gate_purchased()

#Wave Events
signal wave_over()
	

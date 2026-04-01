extends Label

@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_dialogue("start")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_dialogue(event: String):
	if event == "start":
		text = "What... where am I?"
		self.visible = true
		timer.start()


func _on_timer_timeout() -> void:
	self.visible = false

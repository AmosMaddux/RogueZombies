extends Label

@onready var timer: Timer = $Timer

var sequence_name = ""
var sequence_num = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameEvents.set_dialogue.connect(change_dialogue)
	change_dialogue("start", 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_dialogue(event: String, new_sequence_num: int):
	if event == "start":
		sequence_name = event
		
		if new_sequence_num == 0:
			print("0 Sequence Name: " + sequence_name + " Sequence_Num: " + str(sequence_num))
			text = "What... where am I?"
			self.visible = true
			sequence_num += 1
			timer.start()
		elif new_sequence_num == 1:
			print("1 Sequence Name: " + sequence_name + " Sequence_Num: " + str(sequence_num))
			text = "Holy crap! Is that a zombie!?!?"
			sequence_num += 1
			timer.start()
		elif new_sequence_num == 2:
			print("2 Sequence Name: " + sequence_name + " Sequence_Num: " + str(sequence_num))
			self.visible = false
			sequence_num = 0
			sequence_name = ""
		else:
			print("3 Sequence Name: " + sequence_name + " Sequence_Num: " + str(sequence_num))
			print("Sequence num not valid")
	else:
		print("Sequence Name not valid")
		
		
		


func _on_timer_timeout() -> void:
	print("Timer ran out")
	change_dialogue(sequence_name, sequence_num)

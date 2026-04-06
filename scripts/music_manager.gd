extends Node

var audio_player: AudioStreamPlayer

var music: AudioStream = load("res://sfx/main_music.mp3")

func _ready():
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	play_track(music)

func play_track(stream: AudioStream):
	if audio_player.stream == stream and audio_player.playing:
		return # Already playing this track
	
	audio_player.stream = stream
	audio_player.play()

func stop_music():
	audio_player.stop()

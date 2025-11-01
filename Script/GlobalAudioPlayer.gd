extends Node

func add_sfx(stream : AudioStreamWAV):
	var audio_player := AudioStreamPlayer2D.new()
	add_child(audio_player)
	
	audio_player.stream = stream
	audio_player.connect("finished", audio_player.queue_free)
	
	audio_player.pitch_scale = randf_range(0.8, 1.2)
	audio_player.play()

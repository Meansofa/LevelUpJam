extends Button

@onready var click_sfx : AudioStreamWAV = load("res://Art/Music/click.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("pressed", _play_clicked_sound)

func _play_clicked_sound():
	GlobalAudioPlayer.add_sfx(click_sfx)

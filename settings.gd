extends Control

func _on_restart_pressed() -> void:
	print("restart_pressed")
	get_parent().restart()

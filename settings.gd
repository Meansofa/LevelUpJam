extends Control

@export var main : Node2D

func _on_restart_pressed() -> void:
	print("restart_pressed")
	main.restart()

extends Area2D

func change_health(value: int):
	%health_label.text = "[b]" + str(value)

func change_damage(value: int):
	%damage_label.text = "[b]" + str(value)

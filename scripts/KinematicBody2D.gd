extends KinematicBody2D

var health = 100

func _ready() -> void:
	health = 100
	pass

func contact_with_astro_small(damage_astro_small):
	health -= damage_astro_small
	print(health)
	if health <= 0:
		health = 0
		get_parent().queue_free()
	pass
extends RigidBody2D

var damage_astro_small = Global.damage_astro_small
var damage_astro_big = Global.damage_astro_big
var enemy_damage = Global.enemy_damage
var damage_boss = Global.damage_boss
var speed = 400


func _on_Area2D_body_entered(body: Node) -> void:
	if body.has_method("contact_with_astro_small"):
		body.contact_with_astro_small(damage_astro_small)
	
	if body.has_method("contact_with_astro_big"):
		body.contact_with_astro_big(damage_astro_big)
	
	if body.has_method("enemy"):
		body.enemy(enemy_damage)
	
	if body.has_method("damage_boss"):
		body.damage_boss()

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

func damage_asteroides():
	$AudioStreamPlayer.play()
	Global.score += 1
#	queue_free()



func _on_Area2D2_body_entered(body: Node) -> void:
	if body.has_method("sounds"):
		body.sounds()

extends RigidBody2D

var player_damage = 20
var speed = 400


func _on_Area2D_body_entered(body: Node) -> void:
	if body.has_method("player"):
		body.player(player_damage)

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

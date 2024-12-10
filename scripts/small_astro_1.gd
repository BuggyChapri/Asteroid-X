extends Sprite

var damage = 10
var speed = 10

func _process(delta: float) -> void:
	position.x += speed * delta
	rotation += 1 * delta
	pass


func _on_Area2D_body_entered(body: Node) -> void:
	if body.has_method("damage_player"):
		body.damage_player(damage)

func _on_Area2D2_body_entered(body: Node) -> void:
	if body.has_method("damage_asteroides"):
		body.damage_asteroides()


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

func sounds():
	$AudioStreamPlayer.play()

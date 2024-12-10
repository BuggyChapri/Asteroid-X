extends Node2D


func _ready() -> void:
	$AnimationPlayer.play("intro")
	$Timer.start()
	$AudioStreamPlayer.play()
	pass


func _on_Timer_timeout() -> void:
	var dialog = Dialogic.start("story")
	add_child(dialog)

func _on_AudioStreamPlayer_finished() -> void:
	$AudioStreamPlayer.stop()

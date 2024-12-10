extends Control


func _ready() -> void:
	$AudioStreamPlayer.play()
	pass

func _on_Button_pressed() -> void:
	get_tree().change_scene("res://scenes/main.tscn")

func _on_Button2_pressed() -> void:
	get_tree().quit()

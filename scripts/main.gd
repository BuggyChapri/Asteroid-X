extends Node2D

func _ready() -> void:
	var dialog_tut = Dialogic.start("tut")
	add_child(dialog_tut)
	
#	if Global.score >= 49 and Global.score < 60:
#		var dialog = Dialogic.start("boss")
#		add_child(dialog)

	$Timer.start()

func _on_Timer_timeout() -> void:
	Global.sp_enemy = true
	$Timer.stop()

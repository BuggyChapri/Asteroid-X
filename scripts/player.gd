extends KinematicBody2D

onready var bullet_file = preload("res://scenes/player_bullet.tscn")
onready var small_astro_file = preload("res://scenes/small_astro_complete.tscn")
onready var big_astro_file = preload("res://scenes/big_astro.tscn")
onready var enemy_file = preload("res://scenes/enemy.tscn")
onready var boss_file = preload("res://scenes/boss.tscn")

var velocity = Vector2()
var up = Vector2.UP
var speed = 100
var friction = 2
var bullet
var bullet_speed = 600
var reloding = 30
var max_ammo = 30

var boss
var enemy
var is_enemy_sp = false

var health = 100
var max_health
var regen
var astro
var big_astro

var stage_1 = false
var stage_2 = false

var is_boss_spawned = false 

var ran = RandomNumberGenerator.new()


func _ready() -> void:
	$Timer.start()
	$relaod.start()
	$sprite_chooser.start()
	$Timer2.start()
	$enemy_sp.start()
	health = 100
	ran.randomize()
	Global.score = 0
	


	if stage_1 == true:
		$power_up.play()
	if stage_2 == true:
		$power_up.play()

func _process(delta):
	check_stage(delta)
	$CanvasLayer/health.text = str("Health " , health)
	$CanvasLayer/score.text = str("Score " , Global.score)
	$CanvasLayer/Ammo.text = str("Ammo " , reloding)
	
	$CanvasLayer/Label.hide()
	if Global.score >= 170 and Global.score < 189:
		$AnimationPlayer.play("New Anim")
		$CanvasLayer/Label.show()
	
	$CanvasLayer/Label2.hide()
	if is_boss_spawned == true:
		$CanvasLayer/Label2.show()
		$CanvasLayer/Label2.text = str("Space worm ", Global.boss_health)

func check_stage(delta):
	if Global.score >= 99 and Global.score <= 101:
		stage1()
	elif Global.score >= 149 and Global.score <= 151:
		stage2()

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("right"):
		velocity.x = speed
	elif Input.is_action_pressed("left"):
		velocity.x = -speed
	else:
		velocity.x = lerp(velocity.x, 0, friction * delta)
	
	if Input.is_action_pressed("up"):
		velocity.y = -speed
	elif Input.is_action_pressed("down"):
		velocity.y = speed
	else:
		velocity.y = lerp(velocity.y, 0, friction * delta)
	
	if Input.is_action_just_pressed("reload") and reloding <= 30:
		reload()

	var mouse_pos = get_global_mouse_position()
	var direction = mouse_pos - global_position
	var angle = direction.angle()
	rotation = angle
	rotation = angle + PI / 2
	
	if health <= 40 and stage_1 == true:
		regenerate_health()
	elif health <= 70 and stage_2 == true:
		regenerate_health() 
	
	velocity = move_and_slide(velocity,up)
	pass


func _on_Timer_timeout() -> void:
	shoot()
	$Timer.start()

func shoot():
	if Input.is_action_pressed("shoot") and reloding != 0:
			bullet = bullet_file.instance()
			get_parent().add_child(bullet)
			bullet.global_position = $bullet_position.global_position
			bullet.apply_impulse(Vector2(),Vector2(0, -bullet_speed).rotated(rotation))
			bullet.global_rotation = global_rotation
			reloding -= 1
			$shoot.play()
			$Camera2D/camshake.start()

func reload():
	reloding += 30
	
	if reloding >= 30:
		reloding = 30



func _on_sprite_chooser_timeout() -> void:
	var random_sprite_chooser = ran.randi_range(0,1)
	var random_position_chooser = ran.randi_range(0,8)
	
	astro = small_astro_file.instance()
	
	get_parent().add_child(astro)
	$sprite_chooser.start()
	if random_sprite_chooser == 0:
		astro.texture = preload("res://assetes/astro1.png")
	elif random_sprite_chooser == 1:
		astro.texture = preload("res://assetes/astro2.png")
	
	match random_position_chooser:
		0: 
			astro.global_position = $Position2D.global_position
		1:
			astro.global_position = $Position2D2.global_position  
		2: 
			astro.global_position = $Position2D3.global_position 
		3:
			astro.global_position = $Position2D4.global_position  
		4: 
			astro.global_position = $Position2D5.global_position  
		5:
			astro.global_position = $Position2D6.global_position  
		6: 
			astro.global_position = $Position2D7.global_position  
		7: 
			astro.global_position = $Position2D9.global_position  
		8:
			astro.global_position = $Position2D10.global_position  


func damage_player(damage):
	health -= damage
	$Camera2D/camshake.start()
	$death.play()
	if health <= 0:
		health = 0
		get_tree().change_scene("res://scenes/death.tscn")

func _on_Timer2_timeout() -> void:
	big_astro = big_astro_file.instance()
	var random_sprite_chooser = ran.randi_range(0,1)
	var random_position_chooser = ran.randi_range(0,7)
	
	get_parent().add_child(big_astro)
	
	$Timer2.start()
	if random_sprite_chooser == 0:
		big_astro.texture = preload("res://assetes/big_boy_!.png")
	elif random_sprite_chooser == 1:
		big_astro.texture = preload("res://assetes/big_boy_2.png")
	
	match random_position_chooser:
		0:
			big_astro.global_position = $Position_big_astro.global_position
		1: 
			big_astro.global_position = $Position_big_astro2.global_position
		2:
			big_astro.global_position = $Position_big_astro3.global_position  
		3: 
			big_astro.global_position = $Position_big_astro4.global_position  
		4:
			big_astro.global_position = $Position_big_astro5.global_position
		5: 
			big_astro.global_position = $Position_big_astro6.global_position
		6:
			big_astro.global_position = $Position_big_astro7.global_position  
		7: 
			big_astro.global_position = $Position_big_astro8.global_position  			
		
	pass


func _on_Area2D_body_entered(body: Node) -> void:
	if body.has_method("attack_player"):
		body.attack_player()


func player(player_damage):
	$Camera2D/camshake.start()
	$death.play()
	health -= player_damage
	if health <= 0:
		health = 0
		get_tree().change_scene("res://scenes/death.tscn")

func _on_enemy_sp_timeout() -> void:
	if Global.sp_enemy == true:
		enemy = enemy_file.instance()
		get_parent().add_child(enemy)
		var random_position_chooser = ran.randi_range(0,3)
		
		match random_position_chooser:
			0:
				enemy.global_position = $Position_enemy.global_position
			1:
				enemy.global_position = $Position_enemy2.global_position
			3:
				enemy.global_position = $Position_enemy3.global_position
			4:
				enemy.global_position = $Position_enemy4.global_position
	$enemy_sp.start()

func stage1():
	speed = 130
	friction = 4
	health = 200
	max_health = 200
	reloding = 50
	max_ammo = 50
	regen = 0.4
	Global.damage_astro_small = 50
	Global.damage_astro_big = 40
	Global.enemy_damage = 30
	$enemy_sp.wait_time = 3
	stage_1 = true
	$Sprite.texture = preload("res://assetes/lv2.png")
	
	if health <= 40:
		regenerate_health()

func stage2():
	speed = 150
	friction = 6
	health = 300
	reloding = 80
	regen = 1
	max_ammo = 80
	max_health = 300
	bullet_speed = 600
	Global.damage_astro_small = 100
	Global.damage_astro_big = 50
	Global.enemy_damage = 40
	stage_2 = true
	$enemy_sp.wait_time = 1
	$Sprite.texture = preload("res://assetes/lv3.png")

	pass

func regenerate_health():
	if health < max_health:
		health += regen
		health = min(health,max_health)
		pass

func _on_Timer3_timeout() -> void:
	if Global.score >= 199 and Global.score < 201 and not is_boss_spawned:
		print("Spawning Boss")
		is_boss_spawned = true 
		boss() 
		$Timer3.stop()

func boss():
	boss = boss_file.instance()
	get_parent().add_child(boss)
	boss.global_position = $Position2D8.global_position

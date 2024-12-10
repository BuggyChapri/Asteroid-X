extends KinematicBody2D

onready var player: KinematicBody2D = $"../player"
var enemy_bullets_scene = preload("res://scenes/enemy_bullet.tscn")
var enemy_file = preload("res://scenes/enemy.tscn")

var velocity = Vector2()
var speed = 200
var max_health = 6000
var health = Global.boss_health
var target_dir = Vector2() 
var bullet_speed = 700
var is_vis = true
var is_sp = false
var max_enemy = 4
var is_fire = false

var ran = RandomNumberGenerator.new()
var direction_update_timer = 0.5 
var time_since_last_update = 0.0


var fire_rate = 1.5  
var time_since_last_shot = 0.0

func _ready() -> void:
	ran.randomize()
	$Timer.start()  
	$AnimatedSprite.play("default")

func _physics_process(delta: float) -> void:
	time_since_last_update += delta
	time_since_last_shot += delta  

	if is_vis: 
		if time_since_last_update >= direction_update_timer:
			target_dir = (player.position - position).normalized()
			time_since_last_update = 0.0

		velocity = velocity.linear_interpolate(target_dir * speed, 0.1) * delta
		rotation = lerp_angle(rotation, (player.global_position - global_position).angle() + PI / 2, 0.1)

	 
		velocity = move_and_slide(velocity)

   
	if health <= 6000 and health > 5000:
		dash()
	elif health <= 5000 and health > 4000:
		dash()
		spawn()
	elif health <= 4000 and health > 3000:
		shoot()  
	elif health <= 3000 and health > 2000:
		dash()
	elif health <= 2000 and health > 1000:
		dash()
		shoot()
	elif health <= 1000 and health > 0:
		dash()
		shoot()
		spawn()

func dash():
	if is_vis:  
		var random_movement = ran.randi_range(0, 3)
		if random_movement == 0:
			velocity.x = -speed
		elif random_movement == 1:
			velocity.x = speed 
		elif random_movement == 2:
			velocity.y = -speed 
		elif random_movement == 3:
			velocity.y = speed

func shoot():
	if is_vis and time_since_last_shot >= fire_rate: 
		var player_dir = (player.global_position - global_position).normalized()
		var bullet_positions = [$Position2D, $Position2D2, $Position2D3, $Position2D4]
		for pos in bullet_positions:
			var bullet = enemy_bullets_scene.instance()
			bullet.global_position = pos.global_position
			bullet.apply_impulse(Vector2(), player_dir * bullet_speed)
			bullet.rotation = rotation
			get_parent().add_child(bullet)
			$shoot.play()
		is_fire = true
		time_since_last_shot = 0.0  

func spawn():
	if is_vis and is_sp and max_enemy > 0: 
		var enemy_positions = [$Position2D5, $Position2D6, $Position2D7, $Position2D8]
		for pos in enemy_positions:
			var enemy = enemy_file.instance()
			enemy.global_position = pos.global_position
			get_parent().add_child(enemy)
			max_enemy -= 1
			$spwan.play()
	if max_enemy <= 0:
		is_sp = false

func invisible():
	if is_vis:
		visible = false
		$not_visbl.play()
		$CollisionShape2D.disabled = true  
		is_vis = false
		$visibl.start() 

func reappear():
	visible = true
	$CollisionShape2D.disabled = false
	is_vis = true

func damage_boss():
	if is_vis:
		health -= Global.damage_boss
		$death.play()
		if health <= 0:
			die()

func die():
	queue_free()
	get_tree().change_scene("res://scenes/win.tscn")

func _on_visibl_timeout() -> void:
	reappear()
	$visibl.stop()

func _on_Timer2_timeout() -> void:
	if is_fire:
		shoot()  
		$Timer2.start() 

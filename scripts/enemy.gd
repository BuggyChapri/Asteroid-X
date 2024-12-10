extends KinematicBody2D
onready var player: KinematicBody2D = $"../player"
onready var enemy_bullet_file = preload("res://scenes/enemy_bullet.tscn")

var velocity = Vector2()
var speed = 80
var follow = false
var health = 100
var bullt_velocity = Vector2()
var bullet_speed = 700
var enemy_bullet
var is_shoot = false

var ran = RandomNumberGenerator.new()

func _ready() -> void:
	ran.randomize()
	follow = false
	is_shoot = false
	$Timer.start()
	$Timer2.start()
	pass

func _physics_process(delta: float) -> void:
	var dir = (player.position - global_position) * delta 
	if follow == true:
		velocity = dir * speed
	velocity = move_and_slide(velocity)
	pass


func attack_player():
	follow = true
	pass



func _on_Timer_timeout() -> void:
	move()
	$Timer.start()
	
func move():
	var random_movement = ran.randi_range(0,3)
	if random_movement == 0:
		velocity.x = -speed
	elif random_movement == 1:
		velocity.x = speed 
	elif random_movement == 2:
		velocity.y = -speed 
	elif random_movement == 3:
		velocity.y = speed
		pass


func _on_area_body_entered(body: Node) -> void:
	is_shoot = true

func shoot(): 
	if is_shoot == true:
		var player_dir = (player.global_position - global_position).normalized()
		enemy_bullet = enemy_bullet_file.instance()
		get_parent().add_child(enemy_bullet)
		enemy_bullet.global_position = $Position2D.global_position
		enemy_bullet.apply_impulse(Vector2(), player_dir * bullet_speed)
		enemy_bullet.global_rotation = global_rotation
		enemy_bullet.rotation = player_dir.angle()


func enemy(enemy_damage):
	health -= enemy_damage
	$AudioStreamPlayer.play()
	if health <= 0:
		health = 0
		Global.score += 2
		queue_free()


func _on_Timer2_timeout() -> void:
	print(is_shoot)
	if is_shoot == true:
		shoot()
	$Timer2.start()


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_area_body_exited(body: Node) -> void:
	is_shoot = false

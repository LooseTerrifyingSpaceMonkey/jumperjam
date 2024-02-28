class_name Player
extends CharacterBody2D

signal game_over_signal

@onready var animator = $AnimationPlayer
@onready var cshape = $CollisionShape2D

@export var speed = 300.0
@export var accelerometer_speed = 130.0
@export var slowdown_rate = 300.0
@export var margin = 20
@export var gravity = 15.0
@export var max_gravity = 1000
@export var jump_velocity = -800

var viewport_size
var dead = false
var use_accelerometer = false

func _ready():
	viewport_size = get_viewport_rect().size
	
	var os_name = OS.get_name()
	if os_name == "Android" or os_name == "iOS":
		use_accelerometer = true
	
func _process(_delta):
	if velocity.y > 0:
		if animator.current_animation != "fall":
			animator.play("fall")
	elif velocity.y < 0:
		if animator.current_animation != "jump":
			animator.play("jump")
	
func _physics_process(_delta):
	velocity.y += gravity
	velocity.y = minf(velocity.y, max_gravity)
	
	if !dead:
		if use_accelerometer:
			var mobile_direction = Input.get_accelerometer()
			velocity.x = mobile_direction.x * accelerometer_speed
		else:
			var direction = Input.get_axis("move_left", "move_right")
			if direction:
				velocity.x = direction * speed
			else:
				velocity.x = move_toward(velocity.x, 0, slowdown_rate)

	move_and_slide()

	if global_position.x > viewport_size.x + margin:
		global_position.x = -margin
	elif global_position.x < -margin:
		global_position.x = viewport_size.x + margin

func jump():
	velocity.y = jump_velocity
	SoundFX.play("Jump")


func _on_visible_on_screen_notifier_2d_screen_exited():
	die()
	
func die():
	if !dead:
		dead = true
		cshape.set_deferred("disabled", true)
		game_over_signal.emit()
		SoundFX.play("Fall")

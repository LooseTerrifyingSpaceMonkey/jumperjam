class_name Player
extends CharacterBody2D

@export var speed = 300.0
@export var slowdown_rate = 300.0
@export var margin = 20
@export var gravity = 15.0
@export var max_gravity = 1000
@export var jump_velocity = -800

var viewport_size

@onready var animator = $AnimationPlayer

func _ready():
	viewport_size = get_viewport_rect().size
	
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

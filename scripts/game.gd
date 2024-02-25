extends Node2D

var camera_scene = preload("res://scenes/game_camera.tscn")
var player_scene = preload("res://scenes/player.tscn")

@onready var level_generator = $LevelGenerator
@onready var ground_sprite = $GroundSprite
@onready var parallax1 = $ParallaxBackground/ParallaxLayer1
@onready var parallax2 = $ParallaxBackground/ParallaxLayer2
@onready var parallax3 = $ParallaxBackground/ParallaxLayer3

@export var player_spawn_pos_offset = 135

var player: Player = null
var player_spawn_position: Vector2

var camera = null
# Level gen variables
var start_platform_y
var y_distance_between_platforms = 100
var level_size = 10
var viewport_size: Vector2
var generated_platform_count = 0

func _ready():
	viewport_size = get_viewport_rect().size
	player_spawn_position = Vector2(viewport_size.x / 2.0, viewport_size.y - player_spawn_pos_offset)
	
	ground_sprite.global_position = Vector2(viewport_size.x / 2.0, viewport_size.y)
	
	setup_parallax_layer(parallax1)
	setup_parallax_layer(parallax2)
	setup_parallax_layer(parallax3)
	
	new_game()
	
func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
		
func get_parallax_sprite_scale(parallax_sprite: Sprite2D):
	var parallax_texture = parallax_sprite.get_texture()
	var parallax_texture_width = parallax_texture.get_width()
	var scale = viewport_size.x / parallax_texture_width
	var result = Vector2(scale, scale)
	return result
	
func setup_parallax_layer(parallax_layer: ParallaxLayer):
	var parallax_sprite = parallax_layer.find_child("Sprite2D")
	if parallax_sprite:
		parallax_sprite.scale = get_parallax_sprite_scale(parallax_sprite)
		var my = parallax_sprite.scale.y * parallax_sprite.get_texture().get_height()
		parallax_layer.motion_mirroring.y = my
		
func new_game():
	#Create Player
	player = player_scene.instantiate()
	player.global_position = player_spawn_position
	add_child(player)
	
	#Create Camera
	camera = camera_scene.instantiate()
	camera.setup_camera(player)
	add_child(camera)
	
	if player:
		level_generator.setup(player)




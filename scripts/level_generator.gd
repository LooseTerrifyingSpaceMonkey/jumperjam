extends Node2D

var platform_scene = preload("res://scenes/platform.tscn")

@onready var platform_parent = $PlatformParent

var player: Player = null

# Level gen variables
var start_platform_y
var y_distance_between_platforms = 100
var level_size = 10
var viewport_size
var generated_platform_count = 0

func setup(_player: Player):
	if _player:
		player = _player
	
func _ready():
	viewport_size = get_viewport_rect().size
	generated_platform_count = 0
	
	start_platform_y = viewport_size.y - (y_distance_between_platforms * 2)
	
	
func start_generation():
	generate_level(start_platform_y, true)

func _process(_delta):
	if player:
		var player_y = player.global_position.y
		var end_level_position = start_platform_y - (generated_platform_count * y_distance_between_platforms)
		var threshold = end_level_position + (y_distance_between_platforms * 6)
		if player_y <= threshold:
			generate_level(end_level_position, false)

func create_platform(location: Vector2):
	var platform = platform_scene.instantiate()
	platform.global_position = location
	platform_parent.add_child(platform)

func generate_level(start_y: float, generate_ground: bool):
	
	var platform_width = 136
	var platform_height = 62
	
	#Generate the ground
	if generate_ground:
		var ground_layer_platform_count = (viewport_size.x / platform_width) + 1

		for i in range(ground_layer_platform_count):
			var ground_location = Vector2(i * platform_width, viewport_size.y - platform_height)
			create_platform(ground_location)
		
	# Generate the level
	var min_x_position = 0.0
	var max_x_position = viewport_size.x - platform_width
	var location: Vector2
	for i in range(level_size):
		var random_x = randf_range(min_x_position, max_x_position)
		location = Vector2(random_x, start_y - (i * y_distance_between_platforms))
		create_platform(location)
		generated_platform_count += 1

func reset_level():
	generated_platform_count = 0
	for platform in platform_parent.get_children():
		platform.queue_free()

extends CharacterBody2D

@export var speed: float = 80.0
@export var pause_time: float = 1.5
@export var damage: int = 10

# Patrol bounds
@export var min_x: float = 0.0
@export var max_x: float = 200.0

var direction: int = 1
var is_paused: bool = false
var pause_timer: float = 0.0

@onready var ground_check: RayCast2D = $GroundCheck
@onready var vision_area: Area2D = $VisionArea

func _ready() -> void:
	vision_area.body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	if is_paused:
		pause_timer -= delta
		if pause_timer <= 0.0:
			is_paused = false
			direction *= -1
			vision_area.scale.x = direction
		return

	# Move
	velocity.x = direction * speed
	move_and_slide()

	# Check patrol bounds
	if (direction == 1 and global_position.x >= max_x) or (direction == -1 and global_position.x <= min_x):
		_start_pause()

func _start_pause() -> void:
	is_paused = true
	pause_timer = pause_time
	velocity.x = 0
	

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		print("player found")

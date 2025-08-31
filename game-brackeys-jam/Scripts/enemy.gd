class_name Enemy extends CharacterBody2D

@export var speed: float = 80.0
@export var pause_time: float = 4.0
@export var damage: int = 10

# Patrol bounds
@export var min_x: float = 0.0
@export var max_x: float = 200.0

@onready var ground_check: RayCast2D = $GroundCheck
@onready var vision_area: Area2D = $VisionArea

var direction: int = 1
var is_paused: bool = false
var pause_timer: float = 0.0
var attack_timer: float = 0.0

var potential_loot: Dictionary = {"Item1": .10, "Item2": .30, "Item3": .40, "Nothing": .20}
var has_been_looted: bool = false

var player: CharacterBody2D
var game: Node2D


func _ready() -> void:
	game = get_tree().root.get_node("GameScene")

func _physics_process(delta: float) -> void:
	if player:
		attack_timer += delta
		if attack_timer >= 2.0:
			attack_timer = 0.0
			player.health -= 2
	else:
		attack_timer = 0.0
		
	
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
	

func generate_loot() -> String:
	var rand_value = randf()
	var cumulative = 0.0
	
	for item in potential_loot.keys():
		cumulative += potential_loot[item]
		if rand_value <= cumulative:
			has_been_looted = true
			return item
	
	has_been_looted = true
	return potential_loot.keys()[0] 


func _on_vision_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		player = body

func _on_vision_exited(body: Node2D) -> void:
	player = null


func _on_grab_area_body_entered(body: Node2D) -> void:
	pass
	#game.start_combat(self)

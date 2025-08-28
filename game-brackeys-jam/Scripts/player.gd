extends CharacterBody2D

var SPEED = 200
const JUMP_VELOCITY = -300
var jump_value: float = 0


func get_input():
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED/6)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5
	
	get_input()
	move_and_slide()


func _on_detection(area: Area2D) -> void:
	#Monster, world boundary, items, exit
	pass # Replace with function body.

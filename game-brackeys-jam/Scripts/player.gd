extends CharacterBody2D

var SPEED = 125
const JUMP_VELOCITY = -300
var jump_value: float = 0
var was_on_floor: bool

var max_health: int = 6
var health : int = max_health
var attack: int = 2
var defense: int = 2

var enemy: Enemy

var inventory: Dictionary = {"Item1": 0, "Item2": 0}

var temp_timer: Timer

@onready var jump_buffer: Timer = $JumpBuffer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var steal_timer: Timer = $StealTimer
@onready var steal_text: Label = $GUI/VBoxContainer/StealText
@onready var steal_countdown: Label = $GUI/VBoxContainer/StealCountdown
@onready var pickup_label: Label = $GUI/PickupLabel
@onready var stats_label: Label = $CanvasLayer/Control/StatsLabel



func get_input():
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED/6)

func _physics_process(delta: float) -> void:
	get_input()
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if was_on_floor and not is_on_floor():
		coyote_timer.start()
	
	if Input.is_action_just_pressed("jump") and is_on_floor() or Input.is_action_just_pressed("jump") and not coyote_timer.is_stopped():
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("jump") and not is_on_floor():
		jump_buffer.start()
	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = 0
	
	if enemy:
		if not enemy.has_been_looted:
			steal_text.show()
			steal_countdown.show()
			if not steal_timer.is_stopped():
				steal_countdown.set_text(str(int(steal_timer.time_left+1)))
			else:
				steal_countdown.set_text("")
			
			if Input.is_action_just_pressed("interact"):
				steal_timer.start()
			if Input.is_action_just_released("interact") or not steal_text.is_visible_in_tree():
				steal_timer.stop()
				steal_countdown.set_text("")
	else:
		steal_text.hide()
		steal_countdown.hide()
			
			
	was_on_floor = is_on_floor()
	move_and_slide()


func create_temp_timer(time: float):
	temp_timer = Timer.new()
	add_child(temp_timer)
	temp_timer.wait_time = time
	temp_timer.one_shot = true
	temp_timer.timeout.connect(_on_temp_timer_timeout)
	temp_timer.start()
	


func _on_jump_buffer_timeout() -> void:
	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y = JUMP_VELOCITY


func _on_body_detection(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		enemy = body
		


func _on_body_detection_exited(body: Node2D) -> void:
		if body.is_in_group("Enemy"):
			enemy = null
			

func _on_area_detection(area: Area2D) -> void:
	var obj = area.get_parent()
	if obj.is_in_group("Item"):
		var item = obj
		if item.TYPE == "attack":
			attack += item.BUFF_AMOUNT
			pickup_label.set_text("+" + str(item.BUFF_AMOUNT) + " attack damage!")
			pickup_label.show()
			create_temp_timer(2.0)
			stats_label.set_text("Attack: " + str(attack) + "\nDefense: " + str(defense))
			
		elif item.TYPE == "defense":
			defense += item.BUFF_AMOUNT
			pickup_label.set_text("+" + str(item.BUFF_AMOUNT) + " defense!")			
			pickup_label.show()
			create_temp_timer(2.0)
			stats_label.set_text("Attack: " + str(attack) + "\nDefense: " + str(defense))
		## Adding items to inventory if we want to add items that do more than boost stats
		#for item in inventory:
			#if obj.type == item:
				#inventory[item] += 1
				#break
		obj.queue_free()


func _on_steal_timeout() -> void:
	var looted_item = enemy.generate_loot()
	steal_text.hide()
	steal_countdown.set_text("STOLEN: " + str(looted_item))
	create_temp_timer(2.0)
	
	for item in inventory:
		if looted_item == item:
			inventory[item] += 1
			break


func _on_temp_timer_timeout():
	steal_countdown.set_text("")
	steal_countdown.hide()
	pickup_label.set_text("")
	pickup_label.hide()
	temp_timer.queue_free()
<<<<<<< Updated upstream
=======

func increase_attack(amount: int) -> void:
	attack += amount
	print("your attack increased ")
>>>>>>> Stashed changes

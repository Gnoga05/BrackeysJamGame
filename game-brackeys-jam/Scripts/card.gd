extends Node2D

@export var bonus_attack: int = 2

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"): 
		if body.has_method("increase_attack"):
			body.increase_attack(bonus_attack)
		queue_free() 

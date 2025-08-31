extends Node2D

@export var bonus_attack: int = 2

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"): 
		if body.has_method("increase_stat"):
			body.increase_stat(bonus_attack, "attack")
		self.queue_free() 

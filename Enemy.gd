extends RigidBody2D

class_name Enemy

export var min_speed = 150
export var max_speed = 250
var enemy_types = ["walk", "swim", "fly"]

func _ready() -> void:
  $AnimatedSprite.animation = enemy_types[randi() % enemy_types.size()]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#  pass

func _on_Visibility_screen_exited():
  queue_free()
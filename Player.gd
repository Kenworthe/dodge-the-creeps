#
# Following the tutorial at:
# https://docs.godotengine.org/en/3.2/getting_started/step_by_step/your_first_game.html
#

extends Area2D

# defines a custom signal "hit", which Player can emit.
signal hit

class_name Player

# export allows you to view/edit the property in Inspector (Godot UI).
export var speed = 400 # pixels/sec
var screen_size

onready var collision_shape_2d = $CollisionShape2D
var collision_shape_2d_radius
var collision_shape_2d_height

func _ready() -> void:
  screen_size = get_viewport_rect().size
  collision_shape_2d_radius = collision_shape_2d.get_shape().radius
  collision_shape_2d_height = collision_shape_2d.get_shape().height

func _process(delta: float) -> void:
  var velocity = Vector2()

  # Get input, and set velocity accordingly
  if Input.is_action_pressed("ui_up"):
    velocity.y -= 1
  if Input.is_action_pressed("ui_down"):
    velocity.y += 1
  if Input.is_action_pressed("ui_left"):
    velocity.x -= 1
  if Input.is_action_pressed("ui_right"):
    velocity.x += 1

  # Start / stop animation
  if velocity.length() > 0:
    velocity = velocity.normalized() * speed
    $AnimatedSprite.play()
  else:
    $AnimatedSprite.stop()

  # Choose which animation to run
  if velocity.x != 0:
    $AnimatedSprite.animation = "right"
    $AnimatedSprite.flip_v = false
    $AnimatedSprite.flip_h = velocity.x < 0
  elif velocity.y != 0:
    $AnimatedSprite.animation = "up"
    $AnimatedSprite.flip_v = velocity.y > 0

  # Move the player.
  position += velocity * delta
  position.x = clamp(position.x, collision_shape_2d_radius, screen_size.x - collision_shape_2d_radius)
  position.y = clamp(position.y, collision_shape_2d_height + 20, (screen_size.y - collision_shape_2d_height - 20))

func _on_Player_body_entered(body: PhysicsBody2D) -> void:
  hide()  # Player disappears after being hit.
  emit_signal("hit")
  print("I've been hit!!!")
  $CollisionShape2D.set_deferred("disabled", true)

func start(pos):
  position = pos
  show()
  $CollisionShape2D.disabled = false
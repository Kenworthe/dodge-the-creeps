extends Node2D

class_name Main

export (PackedScene) var Enemy
var score

func _ready() -> void:
  randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#  pass


func _on_Player_hit() -> void:
  pass # Replace with function body.

func game_over() -> void:
  $ScoreTimer.stop()
  $MobTimer.stop()

func new_game() -> void:
  score = 0
  $Player.start($StartPosition.position)
  $StartTimer.start()

func _on_StartTimer_timeout() -> void:
  $EnemyTimer.start()
  $ScoreTimer.start()

func _on_ScoreTimer_timeout() -> void:
  score += 1

func _on_EnemySpawnTimer_timeout() -> void:
  # Choose a random location on Path2D.
  $EnemySpawnPath/EnemySpawnLocation.set_offset(randi())

  # Create a Enemy instance and add it to the scene.
  var enemy = Enemy.instance()
  add_child(enemy)

  # Set the enemy's direction perpendicular to the path direction.
  var direction = $EnemySpawnPath/EnemySpawnLocation.rotation + PI / 2

  # Set the enemy's position to a random location.
  enemy.position = $EnemySpawnPath/EnemySpawnLocation.position

  # Add some randomness to the direction.
  direction += rand_range(-PI / 4, PI / 4)
  enemy.rotation = direction

  # Set the velocity (speed & direction).
  enemy.linear_velocity = Vector2(rand_range(enemy.min_speed, enemy.max_speed), 0)
  enemy.linear_velocity = enemy.linear_velocity.rotated(direction)

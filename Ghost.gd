extends CharacterBody2D

@export var speed: int = 50
var slowSpeed = 25
var rng = RandomNumberGenerator.new()
var isMoving = 0
var lastDir = "left"
# REMOVED: var velocity = Vector2() - conflicts with built-in CharacterBody2D velocity
var my_random_number = 3
var isCaged = 0
var forceMoving = 0
var player
var chasing = 0

func _ready():
	player = get_node("../Player")
	rng.randomize()
	newDir()
	
func newDir():
	my_random_number = rng.randi_range(1, 4)
	match my_random_number:
		1:
			lastDir = "up"
		2:
			lastDir = "down"
		3:
			lastDir = "left"
		4:
			lastDir = "right"
	pass

func get_direction():
	velocity = Vector2()  # Use built-in velocity property
	if (lastDir == "right"):
		isMoving = 1
		lastDir = "right"
		velocity.x += 1
	if (lastDir == "left"):
		isMoving = 1
		lastDir = "left"
		velocity.x -= 1
	if (lastDir == "down"):
		isMoving = 1
		lastDir = "down"
		velocity.y += 1
	if (lastDir == "up"):
		isMoving = 1
		lastDir = "up"
		velocity.y -= 1
	if(!MyGlobals.powerUpActive):
		velocity = velocity.normalized() * speed
	else:
		velocity = velocity.normalized() * slowSpeed

func moveUp():
	$EscapeTimer.start()
	velocity.x = 0
	velocity.y = 0
	forceMoving = 1
	lastDir = "up"

# Fixed function name - was *physics*process in original
func _physics_process(delta):
	if (!velocity && forceMoving == 0):
		#print("not moving")
		newDir()
	if(forceMoving):
		velocity.y -= 1
		move_and_slide()  # Removed set_velocity() - not needed in Godot 4
	else:
		get_direction()
	
	#make ghost focus player position, TODO wall check
	if(chasing && !isCaged):
		if(!MyGlobals.powerUpActive):
			velocity = position.direction_to(player.position) * speed
		else:
			velocity = position.direction_to(player.position) * slowSpeed
	if(chasing && MyGlobals.powerUpActive):
		if(!MyGlobals.powerUpActive):
			velocity = position.direction_to(player.position) * -speed
		else:
			velocity = position.direction_to(player.position) * -slowSpeed
	
	move_and_slide()  # Single call, removed set_velocity()

# Fixed signal function names - was *on*Area2D_body_entered in original
func _on_area_2d_body_entered(body):
	if body.is_in_group("Player") && MyGlobals.gameOver == 0:
		print("player hit")
		if(!MyGlobals.powerUpActive):
			get_node("..").resetStage()
			get_parent().get_node("deathSound").play()
		else:
			print("eating ghost")
			var tempCombo = MyGlobals.eatCombo
			MyGlobals.eatCombo = tempCombo + 1
			var spawnPoint = get_parent().get_node("GhostSpawn").position
			self.position = spawnPoint
			var tempScore = MyGlobals.score + (200 * MyGlobals.eatCombo)
			MyGlobals.score = tempScore
			
			get_parent().get_node("ghostSound").play()
			
		#queue_free()
	pass # Replace with function body.

# Fixed function name - was *on*EscapeTimer_timeout in original
func _on_escape_timer_timeout():
	forceMoving = 0
	pass # Replace with function body.

func _on_chasearea_1_body_entered(body):
	if body.is_in_group("Player"):
		print("player chase")
		chasing = 1
	pass # Replace with function body.

func _on_chasearea_1_body_exited(body):
	if body.is_in_group("Player"):
		print("player no chase")
		chasing = 0
	pass # Replace with function body.

func _on_chasearea_2_body_entered(body):
	if body.is_in_group("Player"):
		print("player chase")
		chasing = 1
	pass # Replace with function body.

func _on_chasearea_2_body_exited(body):
	if body.is_in_group("Player"):
		print("player no chase")
		chasing = 0
	pass # Replace with function body.

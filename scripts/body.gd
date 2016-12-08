
extends KinematicBody2D

const SPEED = 4

var attacking = 0
var dodging = 0

var direction = Vector2(0, 0) # has to be global. Dodge uses last direction set

var anim = ""
var anim_next = ""


func _ready():
	set_fixed_process(true)
	set_process_input(true)


# Handles movement and animation
func _fixed_process(delta):
	var movement = Vector2(0, 0)
	var idle_direction = direction

	if (!dodging and !attacking):
		if (Input.is_action_pressed("ui_left")):
			direction.x = -1
			anim_next = "run_left"
		elif (Input.is_action_pressed("ui_right")):
			direction.x = 1
			anim_next = "run_right"
		else:
			direction.x = 0
		
		if (Input.is_action_pressed("ui_up")):
			direction.y = -1
			anim_next = "run_up"
		elif (Input.is_action_pressed("ui_down")):
			direction.y = 1
			anim_next = "run_down"
		else:
			direction.y = 0
		
		# Slow down diagonal movement
		if ((direction.x != 0) and (direction.y != 0)):
			direction /= 1.4
		# Manages idle animations		
		elif (direction == Vector2(0, 0)):
			if (idle_direction.y > 0.5):
				anim_next = "idle_down"
			elif (idle_direction.y < -0.5):
				anim_next = "idle_up"
			elif (idle_direction.x > 0.5):
				anim_next = "idle_right"
			elif (idle_direction.x < -0.5):
				anim_next = "idle_left"
		movement = direction * SPEED

	elif (dodging):
		var logdog = log(dodging)

		dodging -= 1
		anim_next = "dodge"

		# Player has delicate control over dodge direction
		if (Input.is_action_pressed("ui_left")):
			direction.x -= 0.01
		elif (Input.is_action_pressed("ui_right")):
			direction.x += 0.01
		if (Input.is_action_pressed("ui_up")):
			direction.y -= 0.01
		elif (Input.is_action_pressed("ui_down")):
			direction.y += 0.01

		if (logdog >= 0):
			movement = direction * SPEED * logdog

	elif (attacking):
		attacking -= 1

	movement = move(movement)
	# Fixes "sticky walls"
	if (is_colliding()):
		var n = get_collision_normal()
		movement = n.slide(movement)
		move(movement)

	if (anim_next != anim):
		anim = anim_next
		get_node("AnimatedSprite/AnimationPlayer").play(anim)

# Identifies press only events (holding the button shouldn't have an effect)
func _input(event):
	if (event.is_action_pressed("dodge")):
		if (direction != Vector2(0, 0) and !attacking):
			dodging = 30
	elif (event.is_action_pressed("attack")):
		if (!dodging):
			attacking = 10
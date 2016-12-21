
extends RigidBody2D

var action_counter = 0
var direction = Vector2(0, 0)
var accel = 9
var anim = ""

func _ready():
	connect("body_enter", self, "bounce")
	add_to_group("bouncer")
	randomize()
	set_process(true)
	set_fixed_process(true)


func _process(delta):
	action_counter += 1

	if action_counter >= 0:
		if anim != "idle":
			anim = "idle"
			get_node("AnimatedSprite/AnimationPlayer").play("idle")

		direction = Vector2(0, 0)

	if action_counter >= 140:
		action_counter = - 40

		var angle = get_angle_to(get_parent().get_node("Player").get_pos())
		direction = Vector2(sin(angle), cos(angle)) * 450

		# Sets the correct leap sprite
		get_node("AnimatedSprite/AnimationPlayer").stop_all()
		anim = "leap"
		while angle < 0:
			angle += 2 * PI
		# note that degree 0 is south
		if angle > 0.52 and angle <= 1.57: # between 30 and 90
			get_node("AnimatedSprite").set_frame(4)
		elif angle > 1.57 and angle <= 2.61: # between 90 and 150
			get_node("AnimatedSprite").set_frame(5)
		elif angle > 2.61 and angle <= 3.66: # between 150 and 210
			get_node("AnimatedSprite").set_frame(6)
		elif angle > 3.66 and angle <= 4.71: # between 210 and 270
			get_node("AnimatedSprite").set_frame(7)
		elif angle > 4.71 and angle <= 5.75: # between 270 and 330
			get_node("AnimatedSprite").set_frame(8)
		else: # between 330 and 30
			get_node("AnimatedSprite").set_frame(3)

func _fixed_process(delta):
	var current_speed = get_linear_velocity()
	current_speed.x = lerp(current_speed.x, direction.x, accel * delta)
	current_speed.y = lerp(current_speed.y, direction.y, accel * delta)
	set_linear_velocity(current_speed)


func bounce(body):
	print("cat")
	get_mass()
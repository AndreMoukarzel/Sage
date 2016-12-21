
extends RigidBody2D

var action_counter = 0
var direction = Vector2(0, 0)
var accel = 9

func _ready():
	connect("body_enter", self, "bounce")
	add_to_group("bouncer")
	randomize()
	set_process(true)
	set_fixed_process(true)


func _process(delta):
	action_counter += 1

	if action_counter >= 0:
		direction = Vector2(0, 0)

	if action_counter >= 140:
		action_counter = - 25

		var angle = get_angle_to(get_parent().get_node("Player").get_pos())
		direction = Vector2(sin(angle), cos(angle)) * 350


func _fixed_process(delta):
	var current_speed = get_linear_velocity()
	current_speed.x = lerp(current_speed.x, direction.x, accel * delta)
	current_speed.y = lerp(current_speed.y, direction.y, accel * delta)
	set_linear_velocity(current_speed)


func bounce(body):
	print("cat")
	get_mass()
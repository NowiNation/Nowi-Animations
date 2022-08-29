extends KinematicBody2D

export var move_speed:float = 150
export var acceleration:float = 450
export var friction:float = 400
export var idle_timeout:float = 3
export var is_follower:bool = false
export(NodePath) onready var follow_target = get_node_or_null(follow_target) as Node2D
export var follow_distance:float = 50
var timeout:float = 0
var velocity:Vector2 = Vector2.ZERO
onready var anim_player:AnimationPlayer = $AnimationPlayer


func get_input_vector()->Vector2:
	
	if is_follower:
		if global_position.distance_to(follow_target.global_position) <= follow_distance:
			return Vector2.ZERO
		return global_position.direction_to(follow_target.global_position)

	var input_vector:Vector2 = Input.get_vector("move_left","move_right","move_up","move_down")
	input_vector += Input.get_vector("move_left_analog","move_right_analog","move_up_analog","move_down_analog")
	input_vector = input_vector.limit_length()
	return input_vector

func update_animation()->void:
	if Input.is_action_pressed("selected"):
		var pos = anim_player.current_animation_position
		anim_player.play("Selected")
		anim_player.seek(pos,true)
		timeout = 0
		return
	
	if velocity.length() < 0.01:
		timeout -= get_physics_process_delta_time()
		if timeout < 0:
			var pos = anim_player.current_animation_position
			anim_player.play("Idle")
			anim_player.seek(pos,true)
		return
	else:
		timeout = idle_timeout
	
	var anim_name:String = "Move"
	var angle:float = (velocity.angle()+PI)
	if angle > PI/8 and angle < 7*PI/8:
		anim_name += "Up"
	if angle > 9*PI/8 and angle < 15*PI/8:
		anim_name += "Down"
	if angle > 5*PI/8 and angle < 11*PI/8:
		anim_name += "Right"
	if angle > 13*PI/8 or angle < 3*PI/8:
		anim_name += "Left"
	if anim_player.has_animation(anim_name):
		var pos = anim_player.current_animation_position
		anim_player.play(anim_name)
		anim_player.seek(pos,true)


func _physics_process(delta):
	var target_velocity = get_input_vector()*move_speed
	if target_velocity.length() > 0.01:
		velocity = velocity.move_toward(target_velocity,acceleration*delta)
	else:
		velocity = velocity.move_toward(target_velocity,friction*delta)
	velocity = move_and_slide(velocity)
	update_animation()

extends KinematicBody2D


const GRAVITY = 1255.68 # implies 138 pixels = 1 "metre"
const WALK_SPEED = 250
const JUMP = 450
const COYOTE_THRESHOLD = 150 #milliseconds
const JUMP_TIMEOUT = 300
# Bump sound effect stuff
const BUMP_THRESHOLD = 100
const BUMP_TIMEOUT = 250

var speed_factor = 1 # For slowing down time (i.e. accessibility option?)

var velocity = Vector2(0,0)

# Time stamps for various cooldowns
var time_last_on_ground
var time_last_jumped
var time_last_bump

# Custom "on floor" tag ignoring invisible pseudo-obstacles (i.e. StaticBody2D)
var really_on_floor = true

var dying = false
var do_physics = true # disable when dying by spikes

signal moved(offset)


# Called when the node enters the scene tree for the first time.
func _ready():
	time_last_on_ground = OS.get_ticks_msec()
	time_last_jumped = OS.get_ticks_msec()
	time_last_bump = OS.get_ticks_msec()
	emit_signal("moved",global_position)

func coyote_time():
	# Return true during "coyote time"
	return (OS.get_ticks_msec() - time_last_on_ground) < COYOTE_THRESHOLD/speed_factor

func _process(delta):
	$AnimatedSprite.play()
	if velocity.x != 0:
		$AnimatedSprite.flip_h = velocity.x < 0

func handle_key_input(delta):
	# TODO: Actually use delta properly! (I've been doing it wrong this whole time)
	# (i.e. please multiply walk speed/jump velocity by delta, although I will also need to adjust the
	#  hard-coded values appropriately to compensate)
	
	# Key input
	if Input.is_action_pressed("ui_left"):
		velocity.x = -WALK_SPEED
		if really_on_floor and not dying:
			$AnimatedSprite.animation = "run_right"
	elif Input.is_action_pressed("ui_right"):
		velocity.x =  WALK_SPEED
		if really_on_floor and not dying:
			$AnimatedSprite.animation = "run_right"
	else:
		velocity.x = 0
		if really_on_floor and not dying:
			$AnimatedSprite.animation = "standing"
	
	# Jump controls and animations
	if Input.is_action_pressed("ui_up") and can_jump():
		velocity.y =  -JUMP + delta * GRAVITY * speed_factor
		time_last_jumped = OS.get_ticks_msec()
		$JumpSound.play()

func _physics_process(delta):
	if not do_physics:
		return
	
	# Handle falling
	if not is_on_floor():
		if is_on_ceiling() and velocity.y < 0:
			# (Otherwise, weird things happen when hitting a ceiling)
			$JumpSound.stop()
			bump_sound()
			velocity.y = 0
		velocity.y += delta * GRAVITY * speed_factor
		really_on_floor = false
	else: 
		if velocity.y != 0:
			#if abs(velocity.y) > BUMP_THRESHOLD:
				# TODO Particles?
				#$BumpSound.play()
			velocity.y = 0
		if really_on_floor:
			time_last_on_ground = OS.get_ticks_msec()
		
	if not (really_on_floor or coyote_time() or dying):
		$AnimatedSprite.animation = "flailing"
		
	handle_key_input(delta)
	
	# warning-ignore:return_value_discarded
	move_and_slide(velocity * speed_factor,Vector2(0,-1))
	emit_signal("moved",global_position)
	
	# Identify collision with invisible objects
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.get_class() == "StaticBody2D":
			bump_sound()
	
	# Update really_on_floor tag
	# TODO merge with previous.
	if not is_on_floor():
		really_on_floor = false
	elif get_slide_count() > 0:
		really_on_floor = false
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.collider.get_class() != "StaticBody2D":
				really_on_floor = true
				break

func bump_sound():
	var now = OS.get_ticks_msec()
	if now - time_last_bump > BUMP_TIMEOUT:
		$BumpSound.play()
		time_last_bump = now

func disable_physics():
	do_physics = false

func can_jump():
	return coyote_time() and (OS.get_ticks_msec() - time_last_jumped) > JUMP_TIMEOUT

func die(disable_physics=false):
	dying = true
	do_physics = not disable_physics
	$AnimatedSprite.play("death")
	$DeathSound.play()
	Global.reset_pickups()
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().reload_current_scene()

func exit_level():
	# TODO: Make a unique level-exit animation.
	dying = true
	do_physics = false
	$AnimatedSprite.play("death")


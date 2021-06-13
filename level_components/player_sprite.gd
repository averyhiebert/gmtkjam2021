extends KinematicBody2D


const GRAVITY = 1255.68 # implies 138 pixels = 1 "metre"
const WALK_SPEED = 250
const JUMP = 450
const COYOTE_THRESHOLD = 150 #milliseconds
const JUMP_TIMEOUT = 300

var velocity = Vector2(0,0)

# Time stamps for various cooldowns
var time_last_on_ground
var time_last_jumped

# Custom "on floor" tag ignoring invisible pseudo-obstacles (i.e. StaticBody2D)
var really_on_floor = true

var dying = false

signal moved(offset)


# Called when the node enters the scene tree for the first time.
func _ready():
	time_last_on_ground = OS.get_ticks_msec()
	time_last_jumped = OS.get_ticks_msec()

func coyote_time():
	# Return true during "coyote time"
	return OS.get_ticks_msec() - time_last_on_ground < COYOTE_THRESHOLD

func _process(delta):
	$AnimatedSprite.play()
	if velocity.x != 0:
		$AnimatedSprite.flip_h = velocity.x < 0


func _physics_process(delta):
	# Handle falling
	if not is_on_floor():
		if is_on_ceiling() and velocity.y < 0:
			# (Otherwise, weird things happen when hitting a ceiling)
			velocity.y = 0
		velocity.y += delta * GRAVITY
		really_on_floor = false
	else: 
		velocity.y = 0
		if really_on_floor:
			time_last_on_ground = OS.get_ticks_msec()
		
	if not (really_on_floor or coyote_time() or dying):
		$AnimatedSprite.animation = "flailing"
		
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
		velocity.y =  -JUMP + delta*GRAVITY
		time_last_jumped = OS.get_ticks_msec()
	
	# warning-ignore:return_value_discarded
	move_and_slide(velocity,Vector2(0,-1))
	emit_signal("moved",global_position)
	
	# Update really_on_floor tag
	if not is_on_floor():
		really_on_floor = false
	elif get_slide_count() > 0:
		really_on_floor = false
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if collision.collider.get_class() != "StaticBody2D":
				really_on_floor = true
				break

func can_jump():
	return coyote_time() and (OS.get_ticks_msec() - time_last_jumped) > JUMP_TIMEOUT

func die():
	dying = true
	$AnimatedSprite.play("death")
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().reload_current_scene()


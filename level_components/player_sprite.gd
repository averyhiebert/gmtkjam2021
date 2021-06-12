extends KinematicBody2D


const GRAVITY = 1255.68 # implies 138 pixels = 1 "metre"
const WALK_SPEED = 250
const JUMP = 450
const COYOTE_THRESHOLD = 150 #milliseconds
const JUMP_TIMEOUT = 300

var velocity = Vector2(0,0)
# Cooldown should be true during lockout period
var cooldowns = {"jump":false,"flailing":false}

var time_last_on_ground
var time_last_jumped

export(Vector2) var offset_origin

signal moved(offset) # offset relative to offset_origin


# Called when the node enters the scene tree for the first time.
func _ready():
	if not offset_origin:
		offset_origin = position # By default, use start position as offset
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
		if not coyote_time():
			$AnimatedSprite.animation = "flailing"
	else:
		time_last_on_ground = OS.get_ticks_msec() 
		velocity.y = 0
		
	# Key input
	if Input.is_action_pressed("ui_left"):
		velocity.x = -WALK_SPEED
		if is_on_floor():
			$AnimatedSprite.animation = "run_right"
	elif Input.is_action_pressed("ui_right"):
		velocity.x =  WALK_SPEED
		if is_on_floor():
			$AnimatedSprite.animation = "run_right"
	else:
		velocity.x = 0
		if is_on_floor():
			$AnimatedSprite.animation = "standing"
	
	# Jump controls and animations
	if Input.is_action_pressed("ui_up") and can_jump():
		velocity.y =  -JUMP + delta*GRAVITY
		time_last_jumped = OS.get_ticks_msec()
		start_cooldown("jump",0.1)
	
	# warning-ignore:return_value_discarded
	move_and_slide(velocity,Vector2(0,-1))
	#emit_signal("moved",position - offset_origin)
	emit_signal("moved",global_position)

func can_jump():
	return (is_on_floor() or coyote_time()) and (OS.get_ticks_msec() - time_last_jumped) > JUMP_TIMEOUT

func start_cooldown(key,time):
	cooldowns[key] = true
	var timer = Timer.new()
	timer.wait_time = time
	timer.one_shot = true
	timer.connect("timeout", self, "_end_cooldown",[key])
	add_child(timer)
	timer.start()

func _end_cooldown(key):
	cooldowns[key] = false
	


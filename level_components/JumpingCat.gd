extends AnimatedSprite

const JUMP_PROB = 0.1

var rng = RandomNumberGenerator.new()
var timer = Timer.new()

func _ready():
	rng.randomize()
	timer.connect("timeout",self,"random_animation")
	timer.wait_time = rng.randf()*7
	timer.one_shot = false
	add_child(timer)
	timer.start()

func random_animation():
	timer.wait_time = rng.randf()*7
	play("jump")
	yield(self,"animation_finished")
	play("default")
		


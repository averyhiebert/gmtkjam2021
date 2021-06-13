extends Area2D

export(PackedScene) var target
export(float) var delay = 0.7


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered",self,"level_transition")

func level_transition(body):
	# TODO: Nice transition effects?
	yield(get_tree().create_timer(0.25), "timeout")
	body.exit_level()
	$ExitSound.play()
	# Wait 0.5 seconds before transitioning.
	yield(get_tree().create_timer(delay), "timeout")
	get_tree().change_scene_to(target)

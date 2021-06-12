extends Area2D

export(PackedScene) var target


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered",self,"level_transition")

func level_transition(body):
	# TODO: Nice transition effects?
	# Wait 2 seconds before transitioning.
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().change_scene_to(target)

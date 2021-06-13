extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("body_entered",self,"kill")

func kill(body):
	body.die()

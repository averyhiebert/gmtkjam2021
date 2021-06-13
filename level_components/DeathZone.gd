extends Area2D

export(bool) var disable_physics = false

func _ready():
	self.connect("body_entered",self,"kill")

func kill(body):
	body.die(disable_physics)

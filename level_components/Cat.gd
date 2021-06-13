extends AnimatedSprite


export(String) var cat_name = ""

var already_collected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	already_collected = (Global.cat_status[cat_name] != Global.statuses.NO)
	if already_collected:
		visible = false
	$Area2D.connect("body_entered",self,"get_collected")

func get_collected(body):
	if already_collected:
		return
	already_collected = true
	visible = false
	$PickupSound.play()
	Global.pickup(cat_name)

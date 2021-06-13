extends Node2D


func _ready():
	if Global.cat_status["Alice"] == Global.statuses.YES:
		$Alice.visible = true
	if Global.cat_status["Bob"] == Global.statuses.YES:
		$Bob.visible = true
	if Global.cat_status["Charlie"] == Global.statuses.YES:
		$Charlie.visible = true

extends Node2D

var started = OS.get_ticks_msec()

func _ready():
	if Global.cat_status["Alice"] == Global.statuses.YES:
		$Alice.visible = true
	if Global.cat_status["Bob"] == Global.statuses.YES:
		$Bob.visible = true
	if Global.cat_status["Charlie"] == Global.statuses.YES:
		$Charlie.visible = true

func _process(delta):
	if OS.get_ticks_msec() - started < 6000:
		return
		# Key input
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_up"):
		# Restart
		Global.reset_everything()
		get_tree().change_scene_to(load("res://levels/main_levels/level1.tscn"))

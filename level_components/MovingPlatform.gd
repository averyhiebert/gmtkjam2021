extends Node2D

class_name MovingPlatform

# IMPORTANT: First child must implement function "f" which controls motion
var initial_position: Vector2
var pos_func: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_position = global_position
	pos_func = get_child(0)

func update_position(player_position):
	global_position = pos_func.f(initial_position,player_position - initial_position)

func _on_KinematicBody2D_moved(player_position):
	update_position(player_position)

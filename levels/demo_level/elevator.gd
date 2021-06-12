extends Node


func f(pos,ppos):
	return Vector2(pos.x,pos.y + clamp(0.5*ppos.x,-6*32,32))

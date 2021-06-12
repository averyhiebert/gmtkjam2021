extends Node

func f(pos,ppos):
	var y_offset = - ppos.y + ppos.x
	#return Vector2(pos.x,pos.y + clamp(y_offset,-6*32,4*32))
	return Vector2(pos.x,pos.y + y_offset)

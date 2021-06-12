extends Node

func f(pos,ppos):
	return Vector2(pos.x - min(ppos.y,128),pos.y)

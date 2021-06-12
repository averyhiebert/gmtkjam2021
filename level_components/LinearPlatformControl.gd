extends Node

class_name LinearPlatformControl

const BLOCK_SIZE = 32

export(float) var a
export(float) var b
export(float) var c
export(float) var d
export(float) var xmin = -INF
export(float) var xmax = INF
export(float) var ymin = -INF
export(float) var ymax = INF

func f(pos,ppos):
	var x_offset = clamp(a*ppos.x + b*ppos.y,xmin*BLOCK_SIZE,xmax*BLOCK_SIZE)
	var y_offset = clamp(c*ppos.x + d*ppos.y,ymin*BLOCK_SIZE,ymax*BLOCK_SIZE)
	return pos + Vector2(x_offset,y_offset)

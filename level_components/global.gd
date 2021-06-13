extends Node


var music_player

# Called when the node enters the scene tree for the first time.
func _ready():
	music_player = AudioStreamPlayer.new()
	music_player.stream = load("res://assets/audio/modified_crickets.wav")
	music_player.volume_db = -80
	add_child(music_player)
	
	var tween = Tween.new()
	tween.interpolate_property(music_player, "volume_db", -80, -20, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	add_child(tween)
	tween.start()
	music_player.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

extends Node


var music_player

enum statuses {NO,MAYBE,YES}
var cat_status = {
	"Alice":statuses.NO,
	"Bob":statuses.NO,
	"Charlie":statuses.NO,
	"":statuses.YES,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	start_sound()

func start_sound():
	music_player = AudioStreamPlayer.new()
	music_player.stream = load("res://assets/audio/modified_crickets.wav")
	music_player.volume_db = -80
	add_child(music_player)
	
	var tween = Tween.new()
	tween.interpolate_property(music_player, "volume_db", -80, -10, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	add_child(tween)
	tween.start()
	music_player.play()

func pickup(cat):
	if cat in cat_status and cat_status[cat] != statuses.YES:
		cat_status[cat] = statuses.MAYBE

func reset_pickups():
	for cat in cat_status:
		if cat_status[cat] == statuses.MAYBE:
			cat_status[cat] = statuses.NO

func lock_in_pickups():
	for cat in cat_status.keys():
		if cat_status[cat] == statuses.MAYBE:
			cat_status[cat] = statuses.YES

func reset_everything():
	cat_status = {
	"Alice":statuses.NO,
	"Bob":statuses.NO,
	"Charlie":statuses.NO,
	"":statuses.YES,
	}
	

extends ColorRect

func _ready():
	FXPlayer.connect("fade_screen", self, "fade")
	yield(VisualServer, "frame_post_draw")
	fade(0,Color.transparent)

func fade(time, colour):
	$Tween.interpolate_property(self,"modulate",modulate,colour,time)
	$Tween.start()

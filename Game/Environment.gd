extends WorldEnvironment

export(float, 0, 60, 0.1) var glow_duration = 1
export(Curve) var glow_curve

var glow_amount: float = 1
var glow_time = INF

func _ready():
	FXPlayer.connect("glow", self, "glow")


func _process(delta):
	environment.glow_bloom = glow_curve.interpolate(glow_time/glow_duration) * glow_amount
	glow_time += delta

func glow(duration, amount):
	glow_duration = duration
	glow_amount = amount
	glow_time = 0

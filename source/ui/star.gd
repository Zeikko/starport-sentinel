extends AnimatedSprite2D

var speed: float = 0.0

func _ready() -> void:
	generate()

func _process(_delta: float) -> void:
	position.x += speed
	if position.x > 1930: #should be from resolution width, just hardcoded +10 here...
		position.x = -10
		position.y = randi_range(0,64)

func generate():
	var size: float = abs(randfn(1,1))
	if randf() > 0.75: frame = floor(size)
	speed = abs((size-3.0)/20.0) * size
	modulate = [Color("ee8695"), Color("4a7a96"), Color("333f58")].pick_random() #generate colour

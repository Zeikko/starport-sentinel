extends Sprite2D

var speed: float = 0.0

func _ready() -> void:
	generate()

func _process(delta: float) -> void:
	position.x += speed
	if position.x > 1930: #should be from resolution width, just hardcoded +10 here...
		position.x = -10
		generate()

func generate():
	position.y = randi_range(0,64)
	speed = randf_range(0.1,0.25) #generate speed
	frame = randi_range(0,2) #generate size
	modulate = [Color("ee8695"), Color("4a7a96"), Color("333f58")].pick_random() #generate colour

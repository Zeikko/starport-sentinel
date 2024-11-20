extends Node2D

var ship: Ship

var shuttle_body = load("res://ship/radar/shuttle.png")
var frigate_body = load("res://ship/radar/frigate.png")
var cruiser_body = load("res://ship/radar/cruiser.png")
var shuttle_outline = load("res://ship/radar/shuttle_outline.png")
var frigate_outline = load("res://ship/radar/frigate_outline.png")
var cruiser_outline = load("res://ship/radar/cruiser_outline.png")


@onready var body: Sprite2D = $Body
@onready var outline: Sprite2D = $Outline


func _ready() -> void:
	set_radar_texture(ship.information)
	set_radar_outline(ship.information)


func update() -> void:
	if ship.status == Ship.Status.APPROVED:
		body.modulate = Color.html('#333f58')
	elif ship.status == Ship.Status.REJECTED:
		body.modulate = Color.html('#ee8695')


func set_radar_texture(information: ShipInformation) -> void:
	if (information.ship_type == Ship.Type.SHUTTLE):
		body.texture = shuttle_body
	elif (information.ship_type == Ship.Type.FRIGATE):
		body.texture = frigate_body
	elif (information.ship_type == Ship.Type.CRUISER):
		body.texture = cruiser_body


func set_radar_outline(information: ShipInformation) -> void:
	if (information.ship_type == Ship.Type.SHUTTLE):
		outline.texture = shuttle_outline
	elif (information.ship_type == Ship.Type.FRIGATE):
		outline.texture = frigate_outline
	elif (information.ship_type == Ship.Type.CRUISER):
		outline.texture = cruiser_outline

@tool
extends HBoxContainer

@export var cost: int = 100 :
	set(value):
		cost = value
		update_info()

@export var id: String

var bought: bool = false :
	set(value):
		bought = value
		update_info()

@onready var cost_label: Label = %CostLabel
@onready var buy_button: Button = %BuyButton
@onready var description: Label = %Description

func _ready() -> void:
	Game.credits_updated.connect(update_info)
	bought = Game.is_upgrade_bought(id)

func update_info() -> void:
	if is_node_ready():
		cost_label.text = str(cost)
		if Game.credits < cost or bought:
			buy_button.disabled = true
		else:
			buy_button.disabled = false
		if bought:
			buy_button.text = "Sold"
		else:
			buy_button.text = "Buy"

func _on_buy_button_pressed() -> void:
	if Game.credits >= cost and !bought:
		Game.credits -= cost
		bought = true
		Game.upgrade_bought(id)

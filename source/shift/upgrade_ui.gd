extends HBoxContainer

@export var id: Upgrade.Id

var upgrade: Upgrade

@onready var cost_label: Label = %CostLabel
@onready var buy_button: Button = %BuyButton
@onready var description: Label = %Description

func _ready() -> void:
	Game.credits_updated.connect(update_info)
	upgrade = Game.upgrades[id]
	update_info()

func update_info() -> void:
	if is_node_ready():
		cost_label.text = str(upgrade.cost)
		description.text = upgrade.name + " : " + upgrade.description
		if Game.credits < upgrade.cost or upgrade.bought:
			buy_button.disabled = true
		else:
			buy_button.disabled = false
		if upgrade.bought:
			buy_button.text = "Bought"
		else:
			buy_button.text = "Buy"

func _on_buy_button_pressed() -> void:
	if Game.credits >= upgrade.cost and !upgrade.bought:
		Game.credits -= upgrade.cost
		Game.upgrade_bought(id)
		update_info()

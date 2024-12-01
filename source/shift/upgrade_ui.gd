extends HBoxContainer

@export var id: Upgrade.Id

var upgrade: Upgrade
var first_upgrade: bool
@onready var cost_label: Label = %CostLabel
@onready var buy_button: Button = %BuyButton
@onready var description: Label = %Description

func _ready() -> void:
	Global.game.credits_updated.connect(update_info)
	upgrade = Global.game.upgrades[id]
	first_upgrade = true
	update_info()

func update_info() -> void:
	if is_node_ready():
		if first_upgrade:
			upgrade.bought_times = 0
			first_upgrade = false
		if upgrade.id == upgrade.Id.REPAIR:
			cost_label.text = str(upgrade.cost * (upgrade.bought_times + 1))
		else:
			cost_label.text = str(upgrade.cost)
		description.text = upgrade.name + " : " + upgrade.description
		if upgrade.id == upgrade.Id.REPAIR:
			if Global.game.credits < upgrade.cost or Global.game.hit_points == 100:
				buy_button.disabled = true
			else:
				buy_button.disabled = false
			if Global.game.hit_points == 100:
				buy_button.text = "Full"
			else:
				buy_button.text = "Buy"
			return
		if Global.game.credits < upgrade.cost or upgrade.bought:
			buy_button.disabled = true
		else:
			buy_button.disabled = false

		if upgrade.bought:
			buy_button.text = "Bought"
		else:
			buy_button.text = "Buy"

func _on_buy_button_pressed() -> void:
	if Global.game.credits >= upgrade.cost and !upgrade.bought:
		Global.game.credits -= upgrade.cost
		Global.game.upgrade_bought(id)
		upgrade.bought_times += 1
		update_info()

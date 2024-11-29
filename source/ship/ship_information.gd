class_name ShipInformation extends Object

var faction: Ship.Faction
var cargo_items: Array[CargoItem]
var weapon: Ship.Weapon
var ship_type: Ship.Type

func _init(arg_ship: Ship) -> void:
	set_faction(arg_ship)
	set_cargo_items(arg_ship)
	set_weapon(arg_ship)
	set_ship_type(arg_ship)


func set_faction(arg_ship: Ship) -> void:
	faction = arg_ship.faction
	for security_rule: SecurityRule in Global.shift.security_rules:
		if security_rule.rule_type == SecurityRule.Type.FACTION_SHIP_TYPE && \
		security_rule.rule_type == SecurityRule.Type.FACTION_WEAPON:
			var visit_message: String = security_rule.get_visit_message(arg_ship)
			if !visit_message.is_empty():
				faction = Global.game.factions.pick_random()


func set_cargo_items(arg_ship: Ship) -> void:
	var cargo: Dictionary
	for cargo_hold: CargoHold in arg_ship.cargo_holds:
		for cargo_item: CargoItem in cargo_hold.cargo_items:
			var is_item_dangerous: bool = false
			for security_rule: SecurityRule in Global.shift.security_rules:
				if security_rule.rule_type == SecurityRule.Type.CARGO && \
				security_rule.cargo_type == cargo_item.type:
					is_item_dangerous = true
			if !is_item_dangerous:
				if cargo.get(cargo_item.type):
					cargo[cargo_item.type] += cargo_item.quantity
				else:
					cargo[cargo_item.type] = cargo_item.quantity
	for cargo_item_type: CargoItem.Type in cargo.keys():
		cargo_items.push_back(CargoItem.new(cargo_item_type, cargo[cargo_item_type]))


func set_weapon(arg_ship: Ship) -> void:
	weapon = arg_ship.weapon
	for security_rule: SecurityRule in Global.shift.security_rules:
		if security_rule.rule_type == SecurityRule.Type.FACTION_WEAPON:
			var visit_message: String = security_rule.get_visit_message(arg_ship)
			if !visit_message.is_empty():
				weapon = Ship.Weapon.values().pick_random()


func set_ship_type(arg_ship: Ship) -> void:
	ship_type = arg_ship.type
	for security_rule: SecurityRule in Global.shift.security_rules:
		if security_rule.rule_type == SecurityRule.Type.FACTION_SHIP_TYPE:
			var visit_message: String = security_rule.get_visit_message(arg_ship)
			if !visit_message.is_empty():
				ship_type = Ship.Type.values().pick_random()

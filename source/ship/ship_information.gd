class_name ShipInformation extends Object

var faction: Ship.Faction
var cargo_items: Array[CargoItem]

func _init(arg_ship: Ship) -> void:
	set_faction(arg_ship)
	set_cargo_items(arg_ship)

func set_faction(arg_ship: Ship) -> void:
	for security_rule in Shift.security_rules:
		if security_rule.faction == arg_ship.faction && security_rule.ship_type == arg_ship.type && \
		security_rule.rule_type == SecurityRule.Type.FACTION_SHIP_TYPE:
			faction = Ship.Faction.values().pick_random()
			arg_ship.is_dangerous = true
			arg_ship.visit_message = str(
			Ship.Faction.find_key(arg_ship.faction).capitalize(),
			' ',
			Ship.Type.find_key(arg_ship.type).capitalize(),
			' dealt ' + str(arg_ship.damage) + ' damage')
		else:
			faction = arg_ship.faction

func set_cargo_items(arg_ship: Ship) -> void:
	var cargo: Dictionary
	for cargo_hold: CargoHold in arg_ship.cargo_holds:
		for cargo_item: CargoItem in cargo_hold.cargo_items:
			if cargo.get(cargo_item.type):
				cargo[cargo_item.type] += cargo_item.quantity
			else:
				cargo[cargo_item.type] = cargo_item.quantity
	for cargo_item_type: CargoItem.Type in cargo.keys():
		var matching_rules: Array[SecurityRule] = Shift.security_rules.filter(
			func(existing_rule: SecurityRule) -> bool:
			return cargo_item_type == existing_rule.cargo_type && \
			existing_rule.rule_type == SecurityRule.Type.CARGO
		)
		if (matching_rules.size() > 0):
			arg_ship.is_dangerous = true
			arg_ship.visit_message = str(
			'Ship carrying ',
			CargoItem.get_icon(matching_rules[0].cargo_type),
			' dealt ' + str(arg_ship.damage) + ' damage')
		else:
			cargo_items.push_back(CargoItem.new(cargo_item_type, cargo[cargo_item_type]))

class_name SecurityRule extends Object

enum Type {
	CARGO,
	FACTION_SHIP_TYPE,
	FACTION_WEAPON
}
var rule_type: Type
var ship_type: Ship.Type
var faction: Ship.Faction
var cargo_type: CargoItem.Type
var weapon: Ship.Weapon

static func create_security_rule() -> SecurityRule:
	var random_rule_type: Type = Type.values().pick_random()
	match random_rule_type:
		Type.CARGO:
			return create_cargo_rule()
		Type.FACTION_SHIP_TYPE:
			return create_faction_ship_type_rule()
		Type.FACTION_WEAPON:
			return create_faction_weapon_rule()
		_:
			push_warning('Missing security rule creator')
			return null


static func create_cargo_rule() -> SecurityRule:
	var possible_new_rules = CargoItem.Type.values().map(
		func (cargo_type: CargoItem.Type) -> SecurityRule:
		var new_rule = SecurityRule.new()
		new_rule.rule_type = Type.CARGO
		new_rule.cargo_type = cargo_type
		return new_rule
	).filter(func(new_rule: SecurityRule) -> bool:
		return !new_rule.has_identical_rule()
	)
	return possible_new_rules.pick_random()


static func create_faction_ship_type_rule() -> SecurityRule:
	var possible_new_rules: Array[SecurityRule] = []
	for new_faction: Ship.Faction in Ship.Faction.values():
		for new_type: Ship.Type in Ship.Type.values():
			var new_rule = SecurityRule.new()
			new_rule.ship_type = new_type
			new_rule.faction = new_faction
			new_rule.rule_type = Type.FACTION_SHIP_TYPE
			possible_new_rules.push_back(new_rule)
	var nonexisting_rules: Array[SecurityRule] = possible_new_rules.filter(
		func(new_rule: SecurityRule) -> bool: return !new_rule.has_identical_rule()
	)
	return nonexisting_rules.pick_random()


static func create_faction_weapon_rule() -> SecurityRule:
	var possible_new_rules: Array[SecurityRule] = []
	for new_faction: Ship.Faction in Ship.Faction.values():
		for new_weapon: Ship.Weapon in Ship.Weapon.values():
			if (new_weapon != Ship.Weapon.NONE):
				var new_rule = SecurityRule.new()
				new_rule.weapon = new_weapon
				new_rule.faction = new_faction
				new_rule.rule_type = Type.FACTION_WEAPON
				possible_new_rules.push_back(new_rule)
	var nonexisting_rules: Array[SecurityRule] = possible_new_rules.filter(
		func(new_rule: SecurityRule) -> bool: return !new_rule.has_identical_rule()
	)
	return nonexisting_rules.pick_random()

func get_visit_message(arg_ship: Ship) -> String:
	match rule_type:
		Type.CARGO:
			for cargo_hold: CargoHold in arg_ship.cargo_holds:
				for cargo_item: CargoItem in cargo_hold.cargo_items:
					if cargo_item.type == cargo_type:
						return str(
						'Ship carrying ',
						CargoItem.get_icon(cargo_type),
						' dealt ' + str(arg_ship.damage) + ' damage')
		Type.FACTION_SHIP_TYPE:
			if faction == arg_ship.faction && ship_type == arg_ship.type:
				return str(
				Ship.Faction.find_key(arg_ship.faction).capitalize(),
				' ',
				Ship.Type.find_key(arg_ship.type).capitalize(),
				' dealt ',
				arg_ship.damage,
				' damage')
		Type.FACTION_WEAPON:
			if faction == arg_ship.faction && weapon == arg_ship.weapon:
				return str(
				Ship.Faction.find_key(arg_ship.faction).capitalize(),
				' with ',
				Ship.Weapon.find_key(arg_ship.weapon).capitalize(),
				' weapons dealt ',
				arg_ship.damage,
				' damage')
		_:
			push_warning('Missing security rule ship checker')
	return ''

func has_identical_rule() -> bool:
	var existing_identical_rules: Array[SecurityRule] = Shift.security_rules.filter(
		func(existing_rule: SecurityRule) -> bool:
		return faction == existing_rule.faction && \
		ship_type == existing_rule.ship_type && \
		cargo_type == existing_rule.cargo_type && \
		rule_type == existing_rule.rule_type && \
		weapon == existing_rule.weapon
	)
	return existing_identical_rules.size() > 0


func get_nodes() -> Node:
	match rule_type:
		Type.CARGO:
			var icon = CargoItem.get_icon(cargo_type)
			var label: RichTextLabel = RichTextLabel.new()
			label.bbcode_enabled = true
			label.fit_content = true
			label.set_text('No ' + icon)
			return label
		Type.FACTION_SHIP_TYPE:
			var label: Label = Label.new()
			label.set_text('No ' + Ship.Faction.find_key(faction).capitalize() + ' '
			+ Ship.Type.find_key(ship_type).capitalize() + 's')
			return label
		Type.FACTION_WEAPON:
			var label: Label = Label.new()
			label.set_text('No ' + Ship.Faction.find_key(faction).capitalize() + ' '
			+ Ship.Weapon.find_key(weapon).capitalize() + ' weapons')
			return label
		_:
			return null
	return null

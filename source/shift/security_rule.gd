class_name SecurityRule extends Object

enum Type {
	CARGO,
	FACTION_SHIP_TYPE
}
var rule_type: Type
var ship_type: Ship.Type
var faction: Ship.Faction
var cargo_type: CargoItem.Type

static func create_security_rule() -> SecurityRule:
	var rule_type: Type = Type.values().pick_random()
	match rule_type:
		Type.CARGO:
			return create_cargo_rule()
		_:
			return create_faction_type_rule()

static func create_faction_type_rule() -> SecurityRule:
	var possible_new_rules: Array[SecurityRule] = []
	for new_faction: Ship.Faction in Ship.Faction.values():
		for new_type: Ship.Type in Ship.Type.values():
			var new_rule = SecurityRule.new()
			new_rule.ship_type = new_type
			new_rule.faction = new_faction
			new_rule.rule_type = Type.FACTION_SHIP_TYPE
			possible_new_rules.push_back(new_rule)
	var nonexisting_rules: Array[SecurityRule] = possible_new_rules.filter(
		func(new_rule: SecurityRule) -> bool: return !Shift.has_identical_rule(new_rule)
	)
	return nonexisting_rules.pick_random()

static func create_cargo_rule() -> SecurityRule:
	var possible_new_rules = CargoItem.Type.values().map(
		func (cargo_type: CargoItem.Type) -> SecurityRule:
		var new_rule = SecurityRule.new()
		new_rule.rule_type = Type.CARGO
		new_rule.cargo_type = cargo_type
		return new_rule
	).filter(func(new_rule: SecurityRule) -> bool:
		return !Shift.has_identical_rule(new_rule)
	)
	return possible_new_rules.pick_random()

func get_nodes() -> Node:
	if rule_type == Type.FACTION_SHIP_TYPE:
		var label: Label = Label.new()
		label.custom_minimum_size = Vector2(160, 0)
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		label.set_text(Ship.Faction.find_key(faction).capitalize() + ' '
		+ Ship.Type.find_key(ship_type).capitalize() + 's are not allowed')
		return label
	if rule_type == Type.CARGO:
		var icon = CargoItem.get_icon(cargo_type)
		var label: RichTextLabel = RichTextLabel.new()
		label.bbcode_enabled = true
		label.fit_content = true
		label.set_text(icon + ' are not allowed')
		return label
	return null

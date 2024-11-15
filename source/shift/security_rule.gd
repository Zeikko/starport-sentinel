class_name SecurityRule extends Object

var type: Ship.Type = -1
var faction: Ship.Faction = -1
var cargo_type: CargoItem.Type = -1

static func create_security_rule(security_rules: Array[SecurityRule]) -> SecurityRule:
	var rule_type = randi_range(1, 2)
	match rule_type:
		1:
			return create_cargo_rule(security_rules)
		_:
			return create_faction_class_rule(security_rules)


static func create_faction_class_rule(security_rules: Array[SecurityRule]) -> SecurityRule:
	var possible_new_rules: Array[SecurityRule] = []
	for new_faction: Ship.Faction in Ship.Faction.values():
		for new_type: Ship.Type in Ship.Type.values():
			var new_rule = SecurityRule.new()
			new_rule.type = new_type
			new_rule.faction = new_faction
			possible_new_rules.push_back(new_rule)
	var nonexisting_rules: Array[SecurityRule] = possible_new_rules.filter(
		func(new_rule: SecurityRule) -> bool:
		var existing_identical_rules: Array[SecurityRule] = security_rules.filter(
			func(existing_rule: SecurityRule) -> bool:
			return new_rule.faction == existing_rule.faction && new_rule.type == existing_rule.type
		)
		return existing_identical_rules.size() == 0
	)
	return nonexisting_rules.pick_random()

static func create_cargo_rule(security_rules: Array[SecurityRule]) -> SecurityRule:
	var possible_new_types = CargoItem.Type.values().filter(func(cargo_type: CargoItem.Type) -> bool:
		var existing_identical_rules: Array[SecurityRule] = security_rules.filter(
			func(existing_rule: SecurityRule) -> bool:
			return cargo_type == existing_rule.cargo_type
		)
		return existing_identical_rules.size() == 0
	)
	var new_rule = SecurityRule.new()
	new_rule.cargo_type = possible_new_types.pick_random()
	return new_rule

func get_nodes() -> Node:
	if faction != -1 && type != -1:
		var label: Label = Label.new()
		label.custom_minimum_size = Vector2(160, 0)
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		label.set_text(Ship.Faction.find_key(faction).capitalize() + ' '
		+ Ship.Type.find_key(type).capitalize() + 's are not allowed')
		return label
	if cargo_type != -1:
		var icon = CargoItem.get_icon(cargo_type)
		var label: RichTextLabel = RichTextLabel.new()
		label.bbcode_enabled = true
		label.fit_content = true
		label.set_text(icon + ' are not allowed')
		return label
	return null

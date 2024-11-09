class_name SecurityRule extends Object

var type: Ship.Type
var faction: Ship.Faction

func _init(arg_type: Ship.Type, arg_faction: Ship.Faction) -> void:
	type = arg_type
	faction = arg_faction

static func create_security_rule(security_rules: Array[SecurityRule]) -> SecurityRule:
	var possible_new_rules: Array[SecurityRule] = []
	for new_faction: Ship.Faction in Ship.Faction.values():
		for new_type: Ship.Type in Ship.Type.values():
			possible_new_rules.push_back(SecurityRule.new(new_type, new_faction))
	possible_new_rules.filter(func(new_rule: SecurityRule) -> bool:
		var existing_identical_rules: Array[SecurityRule] = security_rules.filter(
			func(existing_rule: SecurityRule) -> bool:
			return new_rule.faction == existing_rule.faction && new_rule.type == existing_rule.type
		)
		return existing_identical_rules.size() == 0
	)
	return possible_new_rules.pick_random()

func to_text() -> String:
	var text: String = ''
	if faction != null:
		text += Ship.Faction.find_key(faction).capitalize() + ' '
	if type != null:
		text += Ship.Type.find_key(type).capitalize() + 's '
	text += 'are not allowed'
	return text

class_name Upgrade extends Resource

enum Id {
	SCANNER_SPEED,
	ARMOR,
	REPAIR
}

@export var id: Id
@export var cost: int = 0
@export var bought_times: int = 0
@export var name: String
@export var description: String
@export var bought: bool = false

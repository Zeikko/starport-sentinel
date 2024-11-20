class_name Cheatcode extends Resource

enum Id {
	SPAWN_SHIPS,
	FAST_SHIPS,
	APPROVE_SHIPS
}

@export var id: Id
@export var name: String
@export var combo: Array[InputEventAction]

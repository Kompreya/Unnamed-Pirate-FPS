extends Resource
class_name ClassesAttributes

enum classlist {
	USELESS,
	SWASHBUCKLER,
	GUNNER,
	POWDER_MONKEY,
}

enum attributelist {
	NONE,
	HUMANOID,
	UNDEAD,
	CURSED,
	GHOST,
}

enum ranklist {
	CAPTAIN,
	FIRST_MATE,
	SECOND_MATE,
	CREW_MATE
}

@export var classes: classlist
@export var attributes: attributelist

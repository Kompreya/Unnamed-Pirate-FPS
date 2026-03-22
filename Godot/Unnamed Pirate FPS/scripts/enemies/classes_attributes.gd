extends Resource
class_name ClassesAttributes

enum ClassList {
	USELESS,
	SWASHBUCKLER,
	GUNNER,
	POWDER_MONKEY,
}

enum AttributeList {
	NONE,
	HUMANOID,
	UNDEAD,
	CURSED,
	GHOST,
}

enum RankList {
	CAPTAIN,
	FIRST_MATE,
	SECOND_MATE,
	CREW_MATE
}

@export var classes: ClassList
@export var attributes: AttributeList

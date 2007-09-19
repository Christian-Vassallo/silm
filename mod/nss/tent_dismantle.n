void _DismantleTent(object oTent, object oPC) {
	CreateItemOnObject(GetTag(oTent), oPC);
	DestroyObject(oTent);
}

void main() {
	object oPC = GetLastUsedBy();
	object oTent = OBJECT_SELF;

	AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0f, 20.0f));
	AssignCommand(oPC, ActionDoCommand(_DismantleTent(oTent, oPC)));
}



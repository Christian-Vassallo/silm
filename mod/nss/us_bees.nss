// Adds nValue to oPlacable
void AddValue(string sResRef, object oPlacable = OBJECT_SELF);

// Creats AreaEffect CREEPING_DOOM
void BeesAttack(object oPC);

void OpenBeesContainer(object oPC, object oContainer);

void main() {
	object oPC = GetLastUsedBy();
	object oContainer = OBJECT_SELF;
	if ( GetTag(oContainer) == "Bienenstock" ) {
		OpenBeesContainer(oPC, oContainer);
	} else {
		string sRessource = GetLocalString(oContainer, "Ressource");
		int nInit = GetLocalInt(oContainer, "Init");
		if ( nInit != TRUE ) {
			SetLocalInt(oContainer, "Init", TRUE);
			AddValue(sRessource);
		}
	}
}

void OpenBeesContainer(object oPC, object oContainer) {

	int nInit = GetLocalInt(oContainer, "Init");
	if ( nInit != TRUE ) {
		SetLocalInt(oContainer, "Init", TRUE);
		AddValue("food_cok_990_020");
	}
	BeesAttack(oPC);
}

void AddValue(string sResRef, object oPlacable = OBJECT_SELF) {
	float nDelay = IntToFloat(d3() * 3600);
	CreateItemOnObject(sResRef, oPlacable, 1);
	DelayCommand(nDelay, AddValue(sResRef, oPlacable));
}

void BeesAttack(object oPC) {
	effect eAOE = EffectAreaOfEffect(AOE_PER_CREEPING_DOOM, "bees_enter", "bees_heart", "bees_exit");
	location lTarget = GetLocation(oPC);
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, 60.0);
}

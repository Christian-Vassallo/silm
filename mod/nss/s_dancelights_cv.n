#include "_gen"

const string KEY = "dlight";

void LeaveParty(object oPC);

void Follow(object oPC);

void Stay();

int ToggleLights();

void Unsummon();

void main() {
	object
	oLight = OBJECT_SELF,
	oPC = GetMaster();

	int nCommand = GetLastAssociateCommand(oLight);
	switch ( nCommand ) {
		// Bugger off.
		case ASSOCIATE_COMMAND_LEAVEPARTY:
			ToPC("Ihr loest die Arkane.", oPC);
			Unsummon();
			break;


		case ASSOCIATE_COMMAND_TOGGLESEARCH:
		case ASSOCIATE_COMMAND_PICKLOCK:
		case ASSOCIATE_COMMAND_DISARMTRAP:
		case ASSOCIATE_COMMAND_ATTACKNEAREST:
			ToPC("Das Tanzende Licht versteht Euren Befehl nicht.", oPC);
			break;

		case ASSOCIATE_COMMAND_FOLLOWMASTER:
			ToPC("Das Tanzende Licht folgt Euch.", oPC);
			Follow(oPC);
			break;

		case ASSOCIATE_COMMAND_STANDGROUND:
			ToPC("Das Tanzende Licht haelt inne.", oPC);
			Stay();
			break;

		case ASSOCIATE_COMMAND_TOGGLECASTING:
			ToPC("Ihr lasst von der Arkane ab.", oPC);
			LeaveParty(oPC);
			break;

		case ASSOCIATE_COMMAND_GUARDMASTER:
		case ASSOCIATE_COMMAND_TOGGLESTEALTH:
			if ( ToggleLights() )
				ToPC("Das Licht erstrahlt in neuem Glanze.", oPC);
			else
				ToPC("Das Licht erlischt voruebergehend.", oPC);

			break;

		case ASSOCIATE_COMMAND_HEALMASTER:
			ToPC("Das Tanzende Licht schenkt Euch waermendes Licht.", oPC);
			break;

		case ASSOCIATE_COMMAND_INVENTORY:
			ToPC("Das Tanzende Licht verfuegt ueber keinen Koerper - geschweige denn ein Inventar.", oPC);
			break;

		case ASSOCIATE_COMMAND_MASTERATTACKEDOTHER:
		case ASSOCIATE_COMMAND_MASTERFAILEDLOCKPICK:
		case ASSOCIATE_COMMAND_MASTERGOINGTOBEATTACKED:
		case ASSOCIATE_COMMAND_MASTERSAWTRAP:
		case ASSOCIATE_COMMAND_MASTERUNDERATTACK:
		case ASSOCIATE_COMMAND_RELEASEDOMINATION:
		case ASSOCIATE_COMMAND_UNPOSSESSFAMILIAR:
		case ASSOCIATE_COMMAND_UNSUMMONANIMALCOMPANION:
		case ASSOCIATE_COMMAND_UNSUMMONFAMILIAR:
		case ASSOCIATE_COMMAND_UNSUMMONSUMMONED:
		default:
			// Unknown command
			break;
	}
}


void Unsummon() {
	RemoveAllEffects(OBJECT_SELF);
	DestroyObject(OBJECT_SELF, 1.0f);
}

void Stay() {
	ClearAllActions(1);
	SetLocalInt(OBJECT_SELF, "follow", 0);
}

void Follow(object oPC) {
	ClearAllActions(1);
	ActionForceFollowObject(oPC, 1.0);
	SetLocalInt(OBJECT_SELF, "follow", 1);
}


void LeaveParty(object oPC) {
	// Make sure we are on.
	if ( !GetLocalInt(OBJECT_SELF, "lightstate") )
		ToggleLights();

	RemoveHenchman(oPC);
	ClearAllActions(1);
	ActionRandomWalk();
	SetCommandable(0);
}


int ToggleLights() {
	ClearAllActions(1);
	RemoveAllEffects(OBJECT_SELF);
	int nLightState = GetLocalInt(OBJECT_SELF, "lightstate");
	nLightState = nLightState == 0 ? 1 : 0;
	SetLocalInt(OBJECT_SELF, "lightstate", nLightState);

	if ( nLightState ) {
		int nLight = Random(7);
		nLight = nLight ==
				 0 ? VFX_DUR_LIGHT_BLUE_15 : nLight ==
				 1 ? VFX_DUR_LIGHT_GREY_15 : nLight == 2 ? VFX_DUR_LIGHT_ORANGE_15 :
				 nLight ==
				 3 ? VFX_DUR_LIGHT_PURPLE_15 : nLight ==
				 4 ? VFX_DUR_LIGHT_RED_15 : nLight == 5 ? VFX_DUR_LIGHT_WHITE_15 :
				 VFX_DUR_LIGHT_YELLOW_15;
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectVisualEffect(nLight)),
			OBJECT_SELF);

	}

	ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectCutsceneGhost()), OBJECT_SELF);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectConcealment(100)), OBJECT_SELF);
	return nLightState;
}

#include "_gen"
#include "inc_cdb"
#include "inc_config"

#include "x2_inc_spellhook"


const string
sPrefix = "ebss";
const int
iMaxShield = 12;

void main() {

	if ( !X2PreSpellCastCode() )
		return;

	object oPC = OBJECT_SELF;


	object oShield = GetItemPossessedBy(oPC, "s_ebs");
	if ( GetIsObjectValid(oShield) ) {
		FloatingTextStringOnCreature("Du hast bereits ein Energieschild.", oPC, FALSE);
		return;
	}

	string r = IntToString(Random(iMaxShield) + 1);
	while ( GetStringLength(r) < 3 )
		r = "0" + r;

	oShield = CreateItemOnObject(sPrefix + r, oPC, 1, "s_ebs");

	int nNow = GetUnixTimestamp();

	SetLocalInt(oShield, "ebs_create", nNow);

	// Duration: 12h (IG time) = 3h RL time
	// Value in seconds
	int nExpireIn = ( ( 12 * 60 ) / C_MINUTES_PER_HOUR ) * 60;
	DelayCommand(IntToFloat(nExpireIn), DestroyObject(oShield));

	SetItemCursedFlag(oShield, TRUE);
	ActionEquipItem(oShield, INVENTORY_SLOT_LEFTHAND);
}


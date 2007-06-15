#include "inc_pgsql"
#include "inc_cdb"

void LoadEffects(object oPC);
void ApplyEffectIfNotExists(object oPC, string sEffect);


void main() {
	object oPC = OBJECT_SELF;

	if ( !GetIsPC(oPC) || GetIsDM(oPC) )
		return;

	// Only run each other heartbeat = each 12s cycle
	if ( GetLocalInt(oPC, "hb_persistency_other") ) {
		SetLocalInt(oPC, "hb_persistency_other", 0);
		return;
	} else
		SetLocalInt(oPC, "hb_persistency_other", 1);



	LoadEffects(oPC);

	int nfx = 0;
	int ncount = GetLocalInt(oPC, "peffect");

	string sEffect = "";
	while ( nfx < ncount ) {

		sEffect = GetLocalString(oPC, "peffect_" + IntToString(nfx));

		ApplyEffectIfNotExists(oPC, sEffect);

		nfx++;
	}

}


void ApplyEffectIfNotExists(object oPC, string sEffect) {
	effect eWhat = SupernaturalEffect(StringToEffect(sEffect));
	int bFound = FALSE;

	//if (!GetIsEffectValid(eWhat)) {
	//    ToPC("Invalid persistent effect: " + sEffect);
	//    return;
	//}

	effect e = GetFirstEffect(oPC);
	while ( GetIsEffectValid(e) ) {
		if (
			GetEffectType(e) == GetEffectType(eWhat)
			&& // GetEffectDurationType(e) == GetEffectDurationType(eWhat) &&
			GetEffectSubType(e) == GetEffectSubType(eWhat)
		) {
			bFound = 1;
			break;
		}

		e = GetNextEffect(oPC);
	}

	if ( !bFound ) {
		// SendMessageToPC(oPC, "Persistente Arkane: " + sEffect);
		ApplyEffectToObject(DTP, eWhat, oPC);
	}
}

void LoadEffects(object oPC) {
	if ( GetLocalInt(oPC, "hb_persistency_loaded") )
		return;

	int nCID = GetCharacterID(oPC);

	if ( !nCID )
		return;

	int nfx = 0;
	pQ(
		"select when,effect,duration_type,duration,veffect from persistent_effects where character = "	+ IntToString(nCID) + ";");
	while ( SQLFetch() ) {
		//string sWhen = SQLGetData(1);
		string sEffect = SQLGetData(2);
		//string sDurationType = SQLGetData(3);

		SetLocalString(oPC, "peffect_" + IntToString(nfx), sEffect);
		nfx++;
	}

	SetLocalInt(oPC, "peffect", nfx);


	SetLocalInt(oPC, "hb_persistency_loaded", 1);
}

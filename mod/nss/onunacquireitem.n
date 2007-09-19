#include "inc_corpse_drop"
#include "inc_events"



void main() {
	object oItem = GetModuleItemLost();
	object oPC = GetModuleItemLostBy();

	string sRes = GetResRef(oItem);

	if ( CorpseDropped(oItem, oPC) )
		return;


	if ( TestStringAgainstPattern("move_**", sRes) && !TestStringAgainstPattern("move_target_**", sRes) ) {
		location lT = GetLocation(oPC);

		string sResRef = GetResRef(oItem);
		string sTag = GetTag(oItem);

		object oN = CreateObject(OBJECT_TYPE_PLACEABLE, sTag, lT, FALSE);

		if ( GetLocalInt(oItem, "placie_id") ) {
			SetLocalInt(oN, "placie_id", GetLocalInt(oItem, "placie_id"));
		}

		SetName(oN, GetName(oItem));

		DestroyObject(oItem);
		return;
	}

	// Run the event script, if available.
	RunEventScript(oItem, EVENT_ITEM_UNACQUIRE, EVENT_PREFIX_ITEM);
}



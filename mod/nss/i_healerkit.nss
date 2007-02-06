#include "_events"
#include "inc_healerkit"


//void UseMedicine(object oPC, object oTarget);
//void UseBandage(object oPC, object oTarget);
//void UseHealerKit(object oPC, object oTarget);

void main() {
	if ( EVENT_ITEM_ACTIVATE != GetEvent() )
		return;

	object oPC = GetItemActivator();
	object oTarget = GetItemActivatedTarget();
	object oItem = GetItemActivated();

	string sResRef = GetResRef(oItem);


	if ( "healerkit" == sResRef )
		UseHealerKit(oPC, oTarget, oItem);

	if ( "bandage" == sResRef )
		AddBandage(oPC, oTarget, oItem);

	if ( "medicine" == sResRef )
		AddMedicine(oPC, oTarget, oItem);
}





//void UseMedicine(object oPC, object oTarget);


//void UseBandage(object oPC, object oTarget);




//void UseHealerKit(object oPC, object oTarget) {

//}

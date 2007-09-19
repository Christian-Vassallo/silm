#include "nw_i0_plot"

//Open a store depending on the tag of the NPC
void TMS_OpenStore(string sStoreRR = "") {

	object oStore = GetLocalObject(OBJECT_SELF, "TMS_Store" + sStoreRR);
	object oItm;

	if ( !GetIsObjectValid(oStore) ) {
		if ( sStoreRR == "" ) {
			oStore = CreateObject(OBJECT_TYPE_STORE,
						 "st_" + GetStringLowerCase(GetTag(OBJECT_SELF)),
						 GetLocation(OBJECT_SELF));
		} else {
			oStore = CreateObject(OBJECT_TYPE_STORE,
						 sStoreRR, GetLocation(OBJECT_SELF));
		}
		/*
		 * Didn't work, sorry, no business.
		 */
		if ( !GetIsObjectValid(oStore) ) {
			ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
			return;
		}

		SetLocalObject(OBJECT_SELF, "TMS_Store" + sStoreRR, oStore);
	}

	if ( GetObjectType(oStore) == OBJECT_TYPE_STORE )
		gplotAppraiseOpenStore(oStore, GetPCSpeaker());
	else
		ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
}

void main() {
	ExecuteScript("merchant_conv", OBJECT_SELF);
	// TMS_OpenStore("st_respriest");
}


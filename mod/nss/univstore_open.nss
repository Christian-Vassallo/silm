#include "inc_univstore"

void main() {
	object oPC = GetLastOpenedBy();

	int bChestOpen = GetLocalInt(OBJECT_SELF, "bChestOpen");

	//Truhe noch nicht in Benutzung
	if ( bChestOpen == FALSE ) {
		//Benutzer der Truhe speichern
		SetLocalObject(OBJECT_SELF, "oChestUser", oPC);

		string sChestId = GetLocalString(OBJECT_SELF, "store_tag");

		if ( sChestId == "" ) {
			SendMessageToAllDMs("Warning: Container " +
				GetName(OBJECT_SELF) +
				" in " +
				LocationToStringPrintable(GetLocation(OBJECT_SELF)) +
				" has no valid ChestId. Set the local string 'store_tag'.");
			SpeakString("Ich funktioniere nicht.");
			AssignCommand(oPC, ClearAllActions());
			AssignCommand(oPC, ActionMoveAwayFromObject(OBJECT_SELF, 0, 5.0));
			return;
		}

		int nCount = 0;

		SQLExecDirect("select `resref`, `stack`, `charges`, `identified`, `name` from `" +
			STORE_TABLE + "` where `container` = " + SQLEscape(sChestId) + ";");


		object oNewItem;
		string sResRef, sName;
		int nStack, nCharg, nIdent;

		while ( SQLFetch() ) {
			sResRef = SQLGetData(1);
			nStack = StringToInt(SQLGetData(2));
			nCharg = StringToInt(SQLGetData(3));
			nIdent = StringToInt(SQLGetData(4));
			sName = SQLGetData(5);

			oNewItem = CreateItemOnObject(sResRef, OBJECT_SELF, nStack);

			if ( sName != "" )
				SetName(oNewItem, sName);

			//Identifiziert oder nicht
			SetIdentified(oNewItem, nIdent == 1);
			if ( nCharg > 0 )
				SetItemCharges(oNewItem, nCharg);

			nCount++;
		}

		//Setzen, dass schon geoeffnet
		SetLocalInt(OBJECT_SELF, "bChestOpen", TRUE);
		//Abschliessen, damit kein anderer oeffnen kann waehrend Benutzung
		SetLocked(OBJECT_SELF, TRUE);

		SendMessageToPC(oPC, "Ladung/Kapazitaet: " +
			IntToString(GetTotalContainerItemSizeSum(OBJECT_SELF)) +
			"/" + IntToString(UnivStore_GetCapacity(OBJECT_SELF)));

		SetLocalInt(OBJECT_SELF, "itemCount", nCount);
	}
	//Truhe schon geoeffnet
	else {
		AssignCommand(oPC, ActionMoveAwayFromObject(OBJECT_SELF, FALSE, 5.0));
		SendMessageToPC(oPC, "Diese Truhe ist in Benutzung. Wartet ab, bis sie frei ist.");
		return;
	}
}

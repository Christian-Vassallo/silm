#include "inc_mnx"
#include "inc_setting"

// Create treasure on an NPC.
// This function will typically be called from within the
// NPC's OnSpawn handler.
void CTG_GenerateNPCTreasure(object oNPC = OBJECT_SELF);


int CreateChainedOnObjectByResRefString(string sResRefStr, object oCreateOn);

void CTG_GenerateNPCTreasure(object oNPC = OBJECT_SELF) {
	struct mnxRet r = mnxCmd("getloot", 
		IntToString(GetRacialType(oNPC)), 
		GetResRef(oNPC), 
		GetTag(oNPC), 
		GetName(oNPC),
		GetLocalString(oNPC, "loot")
	);	
	if (r.error) {
		SendMessageToAllDMs("Error generating loot for " + GetName(oNPC));
		return;
	}
	string loot = r.ret;

	if (gvGetInt("treasure_clean_npcs")) {
		object o = GetFirstItemInInventory(oNPC);
		while (GetIsObjectValid(o)) {
			if (!GetPlotFlag(o))
				DestroyObject(o);
			o = GetNextItemInInventory(oNPC);
		}
	}

	CreateChainedOnObjectByResRefString(loot, oNPC);
}

void CreateStackedItemsOnObject(string sResRef, object oCreateOn, int nCount) {
	if (nCount < 1)
		return;

	if (gvGetInt("craft_use_new_create_code")) {
		object oFirst = CreateItemOnObject(sResRef, oCreateOn, 1);
		SetStolenFlag(oFirst, 1);	
		if (nCount > 1) {
			int i;
			int nMaxStack = StringToInt(Get2DACached("baseitems", "ILRStackSize", GetBaseItemType(oFirst)));
			if (nMaxStack > 1) { // item can be stacked!
				SetItemStackSize(oFirst, GetItemStackSize(oFirst) - 1 + nCount);
			} else {
				for ( i = 1; i < nCount; i++ ) {
					oFirst = CreateItemOnObject(sResRef, oCreateOn, 1);
					SetStolenFlag(oFirst, 1);
				}
			}
		}
	} else {
		object oFirst = CreateItemOnObject(sResRef, oCreateOn, nCount);
	}
}


int GetFactorFromChainString(string sR) {
	int f = 1;
	int iW = FindSubString(sR, ":");
	if ( iW != -1 ) {
		string sub = GetSubString(sR, iW + 1, 1024);
		f = StringToInt(sub);
		if ( f < 0 )
			f = 1;
	}
	return f;
}

string GetResRefFromChainString(string sR) {
	string r = sR;

	int iW = FindSubString(sR, ":");
	if ( iW != -1 ) {
		sR = GetSubString(sR, 0, iW);
	}
	return sR;
}

int CreateChainedOnObjectByResRefString(string sResRefStr, object oCreateOn) {
	int nCreated = 0;
	string sResRef = sResRefStr;
	object oNew;
	string sDelimiter = "#";

	int iSplit = FindSubString(sResRefStr, sDelimiter);
	int iW = -1;
	int fFactor = 1;

	while ( iSplit != -1 ) {
		sResRef = GetSubString(sResRefStr, 0, iSplit);
		sResRefStr = GetSubString(sResRefStr, iSplit + GetStringLength(sDelimiter), 1024);

		fFactor = GetFactorFromChainString(sResRef);
		sResRef = GetResRefFromChainString(sResRef);

		CreateStackedItemsOnObject(sResRef, oCreateOn, fFactor);

		nCreated += fFactor;

		iSplit = FindSubString(sResRefStr, sDelimiter);
	}

	sResRef = sResRefStr;

	fFactor = GetFactorFromChainString(sResRef);
	sResRef = GetResRefFromChainString(sResRef);

	CreateStackedItemsOnObject(sResRef, oCreateOn, fFactor);
	nCreated += fFactor;

	return nCreated;
}


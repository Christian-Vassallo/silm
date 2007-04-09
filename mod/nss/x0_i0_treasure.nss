#include "inc_mnx"
#include "inc_setting"

// Create treasure on an NPC.
// This function will typically be called from within the
// NPC's OnSpawn handler.
void CTG_GenerateNPCTreasure(object oNPC = OBJECT_SELF);


void CreateChainedOnObjectByResRefString(string sResRefStr, object oCreateOn);

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
			if (!GetPlotFlag(o)) {
				DestroyObject(o);
			}
			o = GetNextItemInInventory(oNPC);
		}
	}

	DelayCommand(1.0f, CreateChainedOnObjectByResRefString(loot, oNPC));
}

void CreateStackedItemsOnObject(string sResRef, object oCreateOn, int nCount) {
	if (nCount < 1)
		return;

	if (gvGetInt("treasure_use_new_create_code")) {
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
		int i;
		for (i = 0; i < nCount; i++) {
			/*object oFirst = */CreateItemOnObject(sResRef, oCreateOn, 1);
		}
	}
}


int GetMinFactorFromChainString(string sR) {
	int f = 1;
	int iW = FindSubString(sR, ":");
	if ( iW != -1 ) {
		string sub = GetSubString(sR, iW + 1, 1024);
		f = StringToInt(sub);
		if ( f < 1 )
			f = 1;
	}
	return f;
}

int GetMaxFactorFromChainString(string sR) {
	int f = 1;
	int iW = FindSubString(sR, ".");
	if ( iW != -1 ) {
		string sub = GetSubString(sR, iW + 1, 1024);
		f = StringToInt(sub);
		if ( f < 1 )
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

void CreateChainedOnObjectByResRefString(string sResRefStr, object oCreateOn) {
	int nCreated = 0;
	string sResRef = sResRefStr;
	object oNew;
	string sDelimiter = "#";

	int iSplit = FindSubString(sResRefStr, sDelimiter);
	int iW = -1;
	int nMin, nMax, nActual;

	while ( iSplit != -1 ) {
		sResRef = GetSubString(sResRefStr, 0, iSplit);
		sResRefStr = GetSubString(sResRefStr, iSplit + GetStringLength(sDelimiter), 1024);

		nMin = GetMinFactorFromChainString(sResRef);
		nMax = GetMaxFactorFromChainString(sResRef);
		if (nMax < nMin)
			nMax = nMin;
		nActual = nMin + Random(nMax-nMin + 1);

		sResRef = GetResRefFromChainString(sResRef);

		CreateStackedItemsOnObject(sResRef, oCreateOn, nActual);

		nCreated += nActual;

		iSplit = FindSubString(sResRefStr, sDelimiter);
	}

	sResRef = sResRefStr;

	nMin = GetMinFactorFromChainString(sResRef);
	nMin = GetMaxFactorFromChainString(sResRef);
		if (nMax < nMin)
			nMax = nMin;
	nActual = nMin + Random(nMax-nMin + 1);

	sResRef = GetResRefFromChainString(sResRef);

	CreateStackedItemsOnObject(sResRef, oCreateOn, nActual);
	nCreated += nActual;

	//return nCreated;
}


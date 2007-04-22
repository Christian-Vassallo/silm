#include "inc_mnx"
#include "inc_setting"
#include "inc_cdb"
#include "inc_audit"

// Create treasure on an NPC.
// This function will typically be called from within the
// NPC's OnSpawn handler.
void GenerateNPCTreasure(object oNPC = OBJECT_SELF);


// Generates loot on a player as he hits a stone.
// Gets called on EACH hit.
void GenerateGemChainTreasure(object oStone, object oPlayer);


void CreateChainedOnObjectByResRefString(string sResRefStr, object oCreateOn);

void GenerateGemChainTreasure(object oStone, object oPlayer) {
	if (!GetIsPC(oPlayer))
		return;

	string sTag = GetTag(oStone);
	string sAreaTag = GetTag(GetArea(oStone));
	int nAID = GetAccountID(oPlayer);
	int nCID = GetCharacterID(oPlayer);
	string sAID = IntToString(nAID);
	string sCID = IntToString(nCID);

	struct mnxRet r = mnxCmd("getgemloot",
		sTag,
		sAreaTag,
		sAID,
		sCID
	);

	if (r.error) {
		SendMessageToAllDMs("Error generating loot for a stone: " + sTag + " (" + GetName(oPlayer) + ")");
		return;
	}

	string loot = r.ret;

	if ("" != loot) {
		audit("gemchain", oPlayer, audit_fields("loot", loot, "area", sAreaTag, "stone", sTag), "mining");
	}

	DelayCommand(1.0f, CreateChainedOnObjectByResRefString(loot, oPlayer));
}


void GenerateNPCTreasure(object oNPC = OBJECT_SELF) {
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
		if (gvGetInt("treasure_debug")) {
			SendMessageToAllDMs("treasure> Created first: " + IntToString(GetItemStackSize(oFirst)));
			SendMessageToAllDMs("treasure> following: " + IntToString(nCount));
		}

		if (nCount > 1) {
			int i;
			int nMaxStack = StringToInt(Get2DACached("baseitems", "ILRStackSize", GetBaseItemType(oFirst)));
			if (nMaxStack > 1) { // item can be stacked!
				SetItemStackSize(oFirst, GetItemStackSize(oFirst) - 1 + nCount);
			} else {
				for ( i = 1; i < nCount; i++ ) {
					oFirst = CreateItemOnObject(sResRef, oCreateOn, 1);
				}
			}
		}
	} else {
			CreateItemOnObject(sResRef, oCreateOn, nCount);
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
	
		if (gvGetInt("treasure_debug")) {
			SendMessageToAllDMs("treasure> rrA=" + sResRef);
		}

		sResRef = GetResRefFromChainString(sResRef);
	
		if (gvGetInt("treasure_debug")) {
			SendMessageToAllDMs("treasure> rr=" + sResRef);
			SendMessageToAllDMs("treasure> nmin=" + IntToString(nMin) + " nmax=" + IntToString(nMax) + " nactual=" + IntToString(nActual));
		}

		CreateStackedItemsOnObject(sResRef, oCreateOn, nActual);

		nCreated += nActual;

		iSplit = FindSubString(sResRefStr, sDelimiter);
	}

	sResRef = sResRefStr;
	if (gvGetInt("treasure_debug")) {
		SendMessageToAllDMs("treasure> rrA=" + sResRef);
	}

	nMin = GetMinFactorFromChainString(sResRef);
	nMax = GetMaxFactorFromChainString(sResRef);
	if (nMax < nMin)
		nMax = nMin;
	nActual = nMin + Random(nMax-nMin + 1);
	
	sResRef = GetResRefFromChainString(sResRef);

	if (gvGetInt("treasure_debug")) {
		SendMessageToAllDMs("treasure> rr=" + sResRef);
		SendMessageToAllDMs("treasure> nmin=" + IntToString(nMin) + " nmax=" + IntToString(nMax) + " nactual=" + IntToString(nActual));
	}


	CreateStackedItemsOnObject(sResRef, oCreateOn, nActual);
	nCreated += nActual;

	//return nCreated;
}


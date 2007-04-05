#include "inc_mnx"
#include "inc_craft_hlp"

// Create treasure on an NPC.
// This function will typically be called from within the
// NPC's OnSpawn handler.
void CTG_GenerateNPCTreasure(object oNPC = OBJECT_SELF);



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
	CreateItemOnObjectByResRefString(loot, oNPC, 1, 1);
}

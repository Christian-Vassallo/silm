#include "inc_craft_hlp"


// Creates a raw gem that can be mined.
object CreateRawGem(object oCreateOn, string sName, string sContainedGemResRef);

// Creates a bag of gem dust.
object CreateGemDust(object oCreateOn, object oGem);

/* implementation below */

object CreateRawGem(object oCreateOn, string sName, string sContainedGemResRef) {
	object oG = CreateItemOnObject("gem_raw", oCreateOn, 1, "gem_raw");
	SetLocalString(oG, "gem", sContainedGemResRef);
	SetStolenFlag(oG, 1);
	SetName(oG, "Rohstein: " + sName);
	return oG;
}

object CreateGemDust(object oCreateOn, object oGem) {
	object oD = CreateItemOnObject("rem_gemdust", oCreateOn, 1, "rem_gemdust");
	SetLocalString(oD, "gem", GetResRef(oGem));
	SetStolenFlag(oD, 1);
	SetName(oD, "Edelsteinstaub: " + GetName(oGem));
	return oD;
}

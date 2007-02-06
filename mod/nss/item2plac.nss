#include "inc_dbplac"

void main() {
	object oO = GetItemActivated();
	object oA = GetItemActivator();
	location lT = GetItemActivatedTargetLocation();

	string sResRef = GetResRef(oO);
	string sTag = GetTag(oO);

	// vector vP = GetPosition(oA);

	float fN = GetFacing(oA);

	if ( GetLocalInt(oO, "reverse_facing") ) {
		fN += 180.0;
		while ( fN > 360.0 )
			fN -= 360.0;
	}

	// AssignCommand(oN, SetFacing( fN ));

	lT = Location(GetAreaFromLocation(lT), GetPositionFromLocation(lT), fN);

	object oN = CreateObject(OBJECT_TYPE_PLACEABLE, sTag, lT, FALSE);

	// AssignCommand(oN, SetFacingPoint(vP));




	if ( GetLocalInt(oO, "placie_id") ) {
		SetLocalInt(oN, "placie_id", GetLocalInt(oO, "placie_id"));
	}

	SetName(oN, GetName(oO));

	DestroyObject(oO);

	if ( SAVE_ERROR == SavePlacie(oN, oA) ) {
		SendMessageToPC(oA, "Konnte Placie nicht in der DB speichern - BUG!  Bitte melden.");
	}


	int n = 0, vfx = 0;
	while ( ( vfx = GetLocalInt(oN, "vfx" + IntToString(n)) ) > 0 ) {
		ApplyEffectToObject(DTP, SupernaturalEffect(EffectVisualEffect(vfx)), oN);
		n++;
	}

	RecomputeStaticLighting(GetArea(oA));
}

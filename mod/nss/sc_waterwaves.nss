void main() {
	// DUMMY START ---->>>>
	// Diese Stelle ist nur ein Dummy.... weil das untere irgendwie nicht funzt
	// und mir nun die Geduld fl�ten geht
	int i = 0;
	location lLoc1;
	while ( i < 21 ) {
		lLoc1 = GetLocation(GetWaypointByTag("WP_WaterWaves_" + IntToString(i)));
		ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, EffectVisualEffect(132), lLoc1);
		i++;
	}
	// <<<<---- DUMMY ENDE


//
// Script welches �ber einen Trigger einen Effekt auf eine Wegmarke(gruppe) projeziert
//
// Hierf�r mu� der Trigger folgende Variablen enthalten
// int EffectNo     - Integer-Wert entnommen der visualeffects.2da
// string sEffectWP - Kennzeichnung der Wegpunkte (linker Teil der WP mu� gleich sein)
/*
 * location lLoc;
 * int iEffectNo = GetLocalInt(OBJECT_SELF,"EffectNo");
 * string sEffectWP = GetLocalString(OBJECT_SELF,"EffectWP");
 *
 * object oObj;
 * int iNum=0;
 * while(GetIsObjectValid(oObj = GetWaypointByTag(sEffectWP+"_"+IntToString(iNum)))) {
 * 	lLoc = GetLocation(oObj);
 * 	ApplyEffectAtLocation(DURATION_TYPE_PERMANENT,EffectVisualEffect(iEffectNo),lLoc);
 * 	iNum++;
 * }
 */
}

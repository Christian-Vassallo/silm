void main() {
	//Lokatiion iLok Zielwegpunkt zuweisen
	location lLoc = GetLocation(GetWaypointByTag("EingangHain"));
	//Eintretenes Objekt zuweisen
	object oPC = GetEnteringObject();

	//Falls Objekt Spieler ist
	if ( GetIsPC(oPC) ) {
		//Bringe Objekt zum Wegpunkt
		AssignCommand(oPC, JumpToLocation(lLoc));
		//Inventar des Objekts durchsuchen und Itemobjekten zuweisen
		object oItemA = GetItemPossessedBy(oPC, "AmulettderDruiden");
		object oItemS = GetItemPossessedBy(oPC, "SteinderDruiden");
		//Pr�fen, ob Objekt mindestens ein ItemS und kein ItemA hat
		if ( oItemA == OBJECT_INVALID && oItemS != OBJECT_INVALID ) {

			//Falls ja zerst�re ein ItemA
			DestroyObject(oItemS, 0.1);

		}

	}

}

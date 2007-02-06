void main() {
	//Eintretendes Objekt zuweisen
	object oPC = GetEnteringObject();

	//Falls Objekt Spieler ist
	if ( GetIsPC(oPC) ) {

		//Inventar des Objekts durchsuchen und Itemobjekten zuweisen
		object oItemA = GetItemPossessedBy(oPC, "AmulettderDruiden");
		object oItemS = GetItemPossessedBy(oPC, "SteinderDruiden");

		//Besitzt das Objekt mindestens eines der gesuchten Objekte?
		if ( oItemA != OBJECT_INVALID || oItemS != OBJECT_INVALID ) {
			//Rufe Gesprächsdatei "tk_druidgrove" auf
			ActionStartConversation(oPC, "tk_druidgrove", FALSE);
		}

	}

}


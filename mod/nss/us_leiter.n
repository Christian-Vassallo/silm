//::///////////////////////////////////////////////
//:: TransportScript
//:: us_leiter.nss
//:://////////////////////////////////////////////
/*
 * 	Transportiert den Benutzer des Placebals zum
 * 	Wegpunkt mit dem Tag der lokalen Variable "ziel".
 * 	Kann fuer alle moeglichen Leitern, Falltueren,
 * 	Kletterpunkte, Portale etc. benutzt werden.
 *
 * 	Um bei Tueren die oeffnen Animation zu
 * 	zeigen und zu pruefen ob die Tuer
 * 	verschlossen ist muss der Tag des Objectes mit
 * 	DOOR_* beginnen.
 *
 * 	Um Subrassen, Klassen, und Anmeldestatus zu pruefen
 * 	muss der Tag des Objectes mit OOC_* beginnen.
 *
 * 	Um zu pruefen ob der Spieler berechtigt ist das
 * 	Object zu benutzen und mit hilfe eins so genanntem
 * 	KeyStones freigeschaltet wurde muss das Object eine
 * 	Variable "KeyStone" haben die den entsprechenden
 * 	Namen des Feldes beinhaltet der die Berechtigungen
 * 	in der SQL-Datenbank beinhaltet.
 * 	Bsp: KeyStone = 'elfen_keystone' berechtigt die Chars
 * 	das Portal zu nutzen bei den in der Datenbank das
 * 	Feld elfen_keystone den Wert TRUE beinhaltet.
 *
 */
//:://////////////////////////////////////////////
//:: Created By: Torsten Sens
//:: Created On: 25.04.2005
//:: Last Update: 03.12.2005
//:://////////////////////////////////////////////
#include "inc_decay"
#include "inc_persist"
#include "inc_subr_data"

void main() {
	string sTarget = GetLocalString(OBJECT_SELF, "ziel");
	object oPC = GetLastUsedBy();
	location lLoc = GetLocation(GetWaypointByTag(sTarget));

	// verschliessbare Tuer mit Animation?
	if ( GetStringLeft(GetTag(OBJECT_SELF), 5) == "DOOR_" ) {
		// ist die Tuer nicht verschlossen?
		if ( GetLocked(OBJECT_SELF) == FALSE ) {
			//noch nicht geoeffnet?
			if ( GetLocalInt(OBJECT_SELF, "done") == 0 ) {
				ActionPlayAnimation(ANIMATION_PLACEABLE_OPEN);
				SetLocalInt(OBJECT_SELF, "done", 1); //als geoeffnet markieren
			} else {
				AssignCommand(oPC, JumpToLocation(lLoc));
				ActionPlayAnimation(ANIMATION_PLACEABLE_CLOSE);
				SetLocalInt(OBJECT_SELF, "done", 0); //als geschlossen markieren
			}
		}
	} else {
		AssignCommand(oPC, JumpToLocation(lLoc));
	}
}

//##########################################################################
//#Backenscript                                                            #
//#erstellt 19.02.05                                                       #
//#geändert 22.02.05                                                       #
//##########################################################################

//Backenfunktion
void backen(object oPC, object oOfen, int iAnzahl, int iEi, int iMilch) {

//Variablen deklarieren
	string sFehlschlag = "Das Rezept schlägt fehl, Ihr müsst das ungenießbare Resultat fortwerfen.";

//Anzahl der Zutaten bestimmt Rezept
	switch ( iAnzahl ) {
//Pfannkuchen
		case 4:
			//ist das Rezept korrekt?
			if ( iEi == 2 && iMilch == 1 ) {
				//Erstelle das Produkt und gebe Meldung an Spieler aus
				CreateItemOnObject("FOOD_COK_990", oOfen);
				FloatingTextStringOnCreature("Der Pfannkuchen ist fertig.", oPC, FALSE);
				break;
			} else {
				FloatingTextStringOnCreature(sFehlschlag, oPC, FALSE);
				break;
			}
//Brot
		case 5:
			//ist das Rezept korrekt?
			if ( iEi == 2 && iMilch == 2 ) {
				//Erstelle das Produkt und gebe Meldung an Spieler aus
				CreateItemOnObject("FOOD_COK_991", oOfen);
				FloatingTextStringOnCreature("Das Brot ist fertig.", oPC, FALSE);
				break;
			} else {
				FloatingTextStringOnCreature(sFehlschlag, oPC, FALSE);
				break;
			}
//Kuchen
		case 6:
			//ist das Rezept korrekt?
			if ( iEi == 3 && iMilch == 2 ) {
				//Erstelle das Produkt und gebe Meldung an Spieler aus
				CreateItemOnObject("food_cok_999", oOfen);
				FloatingTextStringOnCreature("Der Kuchen ist fertig.", oPC, FALSE);
				break;
			} else {
				FloatingTextStringOnCreature(sFehlschlag, oPC, FALSE);
				break;
			}
//Alles andere ergibt nix
		default:
			break;
	}

}


//Ofen während des Backvorgangs abschliessen und Feueranimation abspielen
void LockOfen(object oOfen) {
	vector vFlame = GetPosition(oOfen) + ( AngleToVector(GetFacing(oOfen)) * 1.4f );
	location lFlame = Location(GetArea(oOfen), vFlame, GetFacing(oOfen));
	object oFlame = CreateObject(OBJECT_TYPE_PLACEABLE, "lc_flame", lFlame);
	SetLocked(oOfen, TRUE);
	SetLocalObject(oOfen, "lc_flame", oFlame);
}


//Ofen nach dem Backvorgang wieder aufschliessen und Feueranimation stoppen
void UnlockOfen(object oOfen) {
	SetLocked(oOfen, FALSE);
	DestroyObject(GetLocalObject(oOfen, "lc_flame"));
}


//Hauptfunktion
void main() {

	ClearAllActions();
//Variablen deklarieren
	object oOfen = OBJECT_SELF;
	object oPC = GetLastUsedBy();
	object oZutat = GetFirstItemInInventory(oOfen);
	int iAnzahl = 0;
	int iMehl = 0;
	int iEi = 0;
	int iMilch = 0;

//Gegenstände im Ofen identifizieren und zählen
	while ( GetIsObjectValid(oZutat) ) {
		string sTag = GetTag(oZutat);
		if ( sTag == "Mehl" ) {
			iMehl++;
		} else {
			if ( sTag == "FOOD_RAW_996_120" ) {
				iEi++;
			} else {
				if ( sTag == "FOOD_COK_997_060" ) {
					iMilch++;
					//Gibt eine leere Milchflasche ins PC Inv zurück
					CreateItemOnObject("Milkbottle_empty", oPC);
				}
			}
		}
		iAnzahl += 1;
		//Jeder Gegestand, der in den Ofen gelegt wird, wird zerstört, unabhängig davon,
		//ob gebacken werden kann oder nicht
		DestroyObject(oZutat);
		oZutat = GetNextItemInInventory(oOfen);
	}
//Wenn die Anzahl der Gegenstände der Anzahl, die man zum Backen braucht entspricht
//und EIN Mehl vorhanden ist, dann fange an zu backen
	if ( iAnzahl > 3 && iAnzahl < 7 && iMehl == 1 ) {
		FloatingTextStringOnCreature(
			"Ihr schiebt das Backwerk in den Ofen und müsst nun den Backvorgang abwarten.", oPC, FALSE);
		//Ofen abschliessen
		LockOfen(oOfen);
		//Backenfunktion aufrufen
		DelayCommand(30.0, backen(oPC, oOfen, iAnzahl, iEi, iMilch));
		//Ofen wieder aufschliessen
		DelayCommand(28.0, UnlockOfen(oOfen));
	}
}

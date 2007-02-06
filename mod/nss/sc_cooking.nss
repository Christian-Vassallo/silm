//##########################################################################
// Scriptname:        sc_cooking
// Scriptdescription: Kochenscript
// Author:            Kanji
// Dependencies:      hb_hunger script
//                    various items (mostly FOOD_COK_* + special)
// ChangeLogs:        18.04.05 - Erstentwurf
//                    19.04.05 - Ergänzung und Dokumentation der bisherigen Gerichte
//                    21.04.05 - Unterscheidung von Kochstelle & Backofen
//                                  1 - Kochstelle (für Suppen und Braten z.B.)
//                                  2 - Backofen (für Backwerk)
//                               Hierfür wird eine int Variable der Stelle (iCookPlace)
//                               abgefragt und auf binäre (!) Verknüpfung geachtet.
//                               Es ist also möglich eine Kombistelle in einer Küche zu haben
//##########################################################################

// ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
// ALLGEMEINE INFOS zum Essen
// ----- ----- ----- ----- ----- ----- ----- ----- ----- -----

//Nahrungs-Punkte-Grenzen:
//========================
//Schwellwert(pappsatt)        1510
//Schwellwert(hungrig)          120
//Schwellwert(sehr hungrig)      60
//Schwellwert(dringend nötig)    20

//Schema der Nahrungsmittel-Namen:
//================================
//FOOD_COK_XXX_YYY
//FOOD_RAW_XXX_YYY

//Zutaten:            Punkte:   Preis:
//========            =======   ======
// 990 - Honigtopf        020        3
// 994 - Bier             060        5
// 997 - Milch            060        4
// 995 - Wein             060       10
// 000 - Wasser           060        3
// 001 - Schmalz (roh)    120        3
// 003 - Fruechte         480        3

//Essen:               Punkte:   Preis:
//======               =======   ======
//Soups - KENNZAHL FOOD_COK_1XX_YYY - klein (Schälchen)
// 101 - Biersuppe         360        4
// 102 - Brotsuppe         480        3
// 103 - Eiersuppe         480        3
// 104 - Knoblauchsuppe    360        3
// 105 - Mehlsuppe         480        3
// 106 - Pilzragout        480        5
// 107 - Krautsuppe        480        3
// 108 - Kräutercreme      360        4
// 109 - Fischsuppe        520        5
// 110 - Gulaschsuppe      520        5
// 111 - Eintopf           720        4

//Cakes - KENNZAHL FOOD_COK_2XX_YYY - mittel (Kuchen)
// 999 - Kuchen            600       10
// 201 - Honigkuchen       520       12
// 202 - Marmorkuchen      600       10
// 203 - Streusselkuchen   600       10
// 204 - Fruechtekuchen    520       12
// 205 - Grumbel's Kuchen  520       16
// 206 - Lotti's Kuchen    520       16

//Pancakes - KENNZAHL FOOD_COK_3XX_YYY - gemixte Größe
// 301 - Pfannkuchen       360        5
// 302 - Pfannkuchen&Sirup 360        6
// 990 - HinPfannkuchen    480       15
// 303 - Arme Ritter       360        4
// 304 - Schmalzkringel    360        6
// 305 - Kaiserschmarrn    360        5

//Cookies - KENNZAHL FOOD_COK_4XX_YYY - klein (Kekse)
//=======
// 401 - Mürbeteig-Kekse   040        3
// 402 - Butterkeks        040        3
// 403 - Honigsplitter     030        4
// 404 - Pfefferkuchen     040        4
// 405 - Marmeladenplätz.  030        4
// 406 - Rumkugeln         020        6

//Bread  - KENNZAHL FOOD_COK_5XX_YYY - mittel (Brot)
//=====
// 991 - Brot             960         3
// 501 - Knoblauchbrot    720         4
// 502 - Zwergenbrot      840         8
// 503 - Honigbrot        640        12
// 504 - Schmalzbrot      840         5
// 992 - Hafenarbeiterz.  720         3
// 991 - Eiserne Ration   960         3
// 505 - Gewürzbrot       840         6

//EatSmall  - KENNZAHL FOOD_COK_6XX_YYY - klein
//========
// 601 - Rührei           360          3
// 602 - Rührei mit Speck 480          5
// 603 - Spiegelei        360          3
// 604 - Spätzle          480          3
// 605 - Käsespätzle      480          4
// 606 - Überback. Käse   360          5

//EatMedium - KENNZAHL FOOD_COK_7XX_YYY - gemixte Größe
//=========
// 701 - Panierter Karpfen  640        5
// 702 - Forelle blau       640        5
// 703 - Panierte Schnitzel 640        5
// 704 - Überb. Scholle     640        6
// 705 - Überb. Fleisch     640        6
// 706 - Wildschweinragout  840        8
// 707 - Hirschragout       840        8
// 708 - Fisch in Weißwein  640        8
// 709 - Rehrücken&Rotwein  720       12
// 710 - Lachs&Kräutersosse 640       10
// 711 - Krautwickel        720        8
// 712 - Hax'n mit Kraut    960       14
// 993 - Wurst              480        4

//EatSimple - KENNZAHL FOOD_COK_xXX_YYY
//=========
// 998 - Gebr. Fisch      720         10
// 002 - Gebr. Fleisch    720         20
// 996 - Gebr. Ei         240          3
// 997 - Honigmilch       060          4
// 996(!)Käse             600          5
// 987 - Süsse Fruechte   480          8


// ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
// EINZELNE FUNKTIONEN FÜR DIE UNTERKATEGORIEN
// ----- ----- ----- ----- ----- ----- ----- ----- ----- -----

// Suppe
void soup(object oPC, object oOfen, int iAnzahl, int iBier, int iBrot, int iEi, int iFelspilz, int iFisch, int iFleisch, int iFruechte, int iHonigmilch, int iHonig, int iKaese, int iKnoblauch, int iMehl, int iMilch, int iSchmalz, int iSchnaps, int iWaldkraut, int iWasser, int iWein,
		  int iWurst) {
	string sFailure = "Das Rezept schlug fehl. Ihr müsst das ungenießbare Resultat fortwerfen.";

	//Soups (25%=1, 50%=2, 25%=3)
	//===========================
	//Biersuppe           : Wasser + Wasser + Bier + Bier + Brot
	//Brotsuppe           : Wasser + Wasser + Brot + Brot
	//Eiersuppe           : Wasser + Wasser + Ei + Ei + Ei
	//Knoblauchsuppe      : Wasser + Wasser + Knoblauch + Knoblauch + Schmalz
	//Mehlsuppe           : Wasser + Wasser + Mehl + Mehl
	//Pilzragout          : Wasser + Wasser + Felspilz + Felspilz + Schmalz
	//Krautsuppe          : Wasser + Wasser + Waldkraut + Waldkraut + Waldkraut
	//Kräutercreme        : Wasser + Wasser + Milch + Waldkraut
	//Fischsuppe          : Wasser + Wasser + Fisch + Fisch + Waldkraut
	//Gulaschsuppe        : Wasser + Wasser + Fleisch + Fleisch + Knoblauch
	//Eintopf             : Wasser + Wasser + Waldkraut + Wurst + Felspilz + Knoblauch
	string sFoodResRef = "";
	if ( iAnzahl == 5 && iBier == 2 && iBrot == 1 ) {
		sFoodResRef = "FOOD_COK_101_360";                                                           //Biersuppe
	} else if ( iAnzahl == 4 && iBrot == 2 ) {
		sFoodResRef = "FOOD_COK_102_480";                                                           //Brotsuppe
	} else if ( iAnzahl == 5 && iEi == 3 ) {
		sFoodResRef = "FOOD_COK_103_480";                                                           //Eiersuppe
	} else if ( iAnzahl == 5 && iKnoblauch == 2 && iSchmalz == 1 ) {
		sFoodResRef = "FOOD_COK_104_360";                                                           //Knoblauchsuppe
	} else if ( iAnzahl == 4 && iMehl == 2 ) {
		sFoodResRef = "FOOD_COK_105_480";                                                           //Mehlsuppe
	} else if ( iAnzahl == 5 && iFelspilz == 2 && iSchmalz == 1 ) {
		sFoodResRef = "FOOD_COK_106_480";                                                           //Pilzragout
	} else if ( iAnzahl == 5 && iWaldkraut == 3 ) {
		sFoodResRef = "FOOD_COK_107_480";                                                           //Krautsuppe
	} else if ( iAnzahl == 4 && iMilch == 1 && iWaldkraut == 1 ) {
		sFoodResRef = "FOOD_COK_108_360";                                                           //Kräutercreme
	} else if ( iAnzahl == 5 && iFisch == 2 && iWaldkraut == 1 ) {
		sFoodResRef = "FOOD_COK_109_520";                                                           //Fischsuppe
	} else if ( iAnzahl == 5 && iFleisch == 2 && iKnoblauch == 1 ) {
		sFoodResRef = "FOOD_COK_110_520";                                                           //Gulaschsuppe
	} else if ( iAnzahl == 6 && iWurst == 1 && iFelspilz == 1 && iKnoblauch == 1 ) {
		sFoodResRef = "FOOD_COK_111_720";                                                           //Eintopf
	}
	if ( sFoodResRef == "" ) {
		FloatingTextStringOnCreature(sFailure, oPC, FALSE);
	} else {
		int iW20 = d20();
		// Chance auf Anzahl Soup (25%=1, 50%=2, 25%=3)
		if ( iW20 > 15 ) CreateItemOnObject(sFoodResRef, oOfen);
		if ( iW20 >  5 ) CreateItemOnObject(sFoodResRef, oOfen);
		CreateItemOnObject(sFoodResRef, oOfen);
		FloatingTextStringOnCreature("Die Suppe ist fertig.", oPC, FALSE);
	}
}
// Kuchen
void cake(object oPC, object oOfen, int iAnzahl, int iBier, int iBrot, int iEi, int iFelspilz, int iFisch, int iFleisch, int iFruechte, int iHonigmilch, int iHonig, int iKaese, int iKnoblauch, int iMehl, int iMilch, int iSchmalz, int iSchnaps, int iWaldkraut, int iWasser, int iWein,
		  int iWurst) {
	string sFailure = "Das Rezept schlug fehl. Ihr müsst das ungenießbare Resultat fortwerfen.";

	//Cakes (45%=1, 55%=2)
	//====================
	//Kuchen              : Milch + Honigmilch + Ei + Ei + Mehl
	//Honigkuchen         : Milch + Honigmilch + Ei + Ei + Mehl + Honig
	//Marmorkuchen        : Milch + Honigmilch + Ei + Ei + Mehl + Ei
	//Streusselkuchen     : Milch + Honigmilch + Ei + Ei + Mehl + Mehl
	//Fruechtekuchen      : Milch + Honigmilch + Ei + Ei + Mehl + Fruechte
	//Grumbel's Kuchen    : Milch + Honigmilch + Ei + Ei + Mehl + Wein
	//Lotti's Kuchen      : Milch + Honigmilch + Ei + Ei + Mehl + Schnaps
	string sFoodResRef = "";
	if ( iAnzahl == 5 ) {
		sFoodResRef = "food_cok_999";                                                          //Kuchen
	} else if ( iAnzahl == 6 && iHonig == 1 ) {
		sFoodResRef = "FOOD_COK_201_520";                                                          //Honigkuchen
	} else if ( iAnzahl == 6 && iEi == 1 ) {
		sFoodResRef = "FOOD_COK_202_600";                                                          //Marmorkuchen
	} else if ( iAnzahl == 6 && iMehl == 2 ) {
		sFoodResRef = "FOOD_COK_203_600";                                                          //Streusselkuchen
	} else if ( iAnzahl == 6 && iFruechte == 2 ) {
		sFoodResRef = "FOOD_COK_204_520";                                                          //Fruechtekuchen
	} else if ( iAnzahl == 6 && iWein == 1 ) {
		sFoodResRef = "FOOD_COK_205_520";                                                          //Grumbel's Kuchen
	} else if ( iAnzahl == 6 && iSchnaps == 1 ) {
		sFoodResRef = "FOOD_COK_206_520";                                                          //Lotti's Kuchen
	}
	if ( sFoodResRef == "" ) {
		FloatingTextStringOnCreature(sFailure, oPC, FALSE);
	} else {
		int iW20 = d20();
		// Chance auf Anzahl Cakes (45%=1, 55%=2)
		if ( iW20 > 9 ) CreateItemOnObject(sFoodResRef, oOfen);
		CreateItemOnObject(sFoodResRef, oOfen);
		FloatingTextStringOnCreature("Der Kuchen ist fertig.", oPC, FALSE);
	}
}
// Pfannkuchen
void pancakes(object oPC, object oOfen, int iAnzahl, int iBier, int iBrot, int iEi, int iFelspilz, int iFisch, int iFleisch, int iFruechte, int iHonigmilch, int iHonig, int iKaese, int iKnoblauch, int iMehl, int iMilch, int iSchmalz, int iSchnaps, int iWaldkraut, int iWasser, int iWein,
			  int iWurst) {
	string sFailure = "Das Rezept schlug fehl. Ihr müsst das ungenießbare Resultat fortwerfen.";

	//Pancakes (10%=1, 70%=2, 15%=3, 5%=4)
	//====================================
	//Pfannkuchen         : Milch + Ei + Mehl
	//Pfannkuchen & Sirup : Milch + Ei + Mehl + Honig
	//HinPfannkuchen      : Milch + Ei + Mehl + Honig + Schmalz
	//Arme Ritter         : Milch + Ei + Mehl + Honigmilch
	//Schmalzkringel      : Milch + Ei + Mehl + Schmalz
	//Kaiserschmarrn      : Milch + Ei + Mehl + Fruechte
	string sFoodResRef = "";
	if ( iAnzahl == 3 ) {
		sFoodResRef = "FOOD_COK_301_360";                                                          //Pfannkuchen
	} else if ( iAnzahl == 4 && iHonig == 1 ) {
		sFoodResRef = "FOOD_COK_302_360";                                                          //Pfannkuchen & Sirup
	} else if ( iAnzahl == 5 && iHonig == 1 && iSchmalz == 1 ) {
		sFoodResRef = "FOOD_COK_990";                                                          //HinPfannkuchen
	} else if ( iAnzahl == 4 && iHonigmilch == 1 ) {
		sFoodResRef = "FOOD_COK_303_360";                                                          //Arme Ritter
	} else if ( iAnzahl == 4 && iSchmalz == 1 ) {
		sFoodResRef = "FOOD_COK_304_360";                                                          //Schmalzkringel
	} else if ( iAnzahl == 4 && iFruechte == 1 ) {
		sFoodResRef = "FOOD_COK_305_360";                                                          //Kaiserschmarrn
	}
	if ( sFoodResRef == "" ) {
		FloatingTextStringOnCreature(sFailure, oPC, FALSE);
	} else {
		int iW20 = d20();
		// Chance auf Anzahl Pancakes (10%=1, 70%=2, 15%=3, 5%=4)
		if ( iW20 > 19 ) CreateItemOnObject(sFoodResRef, oOfen);
		if ( iW20 > 16 ) CreateItemOnObject(sFoodResRef, oOfen);
		if ( iW20 >  2 ) CreateItemOnObject(sFoodResRef, oOfen);
		CreateItemOnObject(sFoodResRef, oOfen);
		FloatingTextStringOnCreature("Die Pfannkuchen sind fertig.", oPC, FALSE);
	}
}
// Plätzchen
void cookies(object oPC, object oOfen, int iAnzahl, int iBier, int iBrot, int iEi, int iFelspilz, int iFisch, int iFleisch, int iFruechte, int iHonigmilch, int iHonig, int iKaese, int iKnoblauch, int iMehl, int iMilch, int iSchmalz, int iSchnaps, int iWaldkraut, int iWasser, int iWein,
			 int iWurst) {
	string sFailure = "Das Rezept schlug fehl. Ihr müsst das ungenießbare Resultat fortwerfen.";

	//Cookies (5%=3, 15%=4, 30%=5, 30%=6, 15%=7, 5%=8)
	//================================================
	//Mürbeteig-Kekse     : Honigmilch + Ei + Mehl
	//Butterkeks          : Honigmilch + Ei + Mehl + Milch + Schmalz
	//Honigsplitter       : Honigmilch + Ei + Mehl + Honig
	//Pfefferkuchen       : Honigmilch + Ei + Mehl + Waldkraut
	//Marmeladenplätzchen : Honigmilch + Ei + Mehl + Fruechte
	//Rumkugeln           : Honigmilch + Ei + Mehl + Schnaps
	string sFoodResRef = "";
	if ( iAnzahl == 3 ) {
		sFoodResRef = "FOOD_COK_401_040";                                                          //Mürbeteig-Kekse
	} else if ( iAnzahl == 5 && iMilch == 1 && iSchmalz == 1 ) {
		sFoodResRef = "FOOD_COK_402_040";                                                          //Butterkeks
	} else if ( iAnzahl == 4 && iHonig == 1 ) {
		sFoodResRef = "FOOD_COK_403_030";                                                          //Honigsplitter
	} else if ( iAnzahl == 4 && iWaldkraut == 1 ) {
		sFoodResRef = "FOOD_COK_404_040";                                                          //Pfefferkuchen
	} else if ( iAnzahl == 4 && iFruechte == 1 ) {
		sFoodResRef = "FOOD_COK_405_030";                                                          //Marmeladenplätzchen
	} else if ( iAnzahl == 4 && iSchnaps == 1 ) {
		sFoodResRef = "FOOD_COK_406_020";                                                          //Rumkugeln
	}
	if ( sFoodResRef == "" ) {
		FloatingTextStringOnCreature(sFailure, oPC, FALSE);
	} else {
		int iW20 = d20();
		// Chance auf Anzahl Cookies (5%=3, 15%=4, 30%=5, 30%=6, 15%=7, 5%=8)
		if ( iW20 > 19 ) CreateItemOnObject(sFoodResRef, oOfen);
		if ( iW20 > 16 ) CreateItemOnObject(sFoodResRef, oOfen);
		if ( iW20 > 10 ) CreateItemOnObject(sFoodResRef, oOfen);
		if ( iW20 >  4 ) CreateItemOnObject(sFoodResRef, oOfen);
		if ( iW20 >  1 ) CreateItemOnObject(sFoodResRef, oOfen);
		CreateItemOnObject(sFoodResRef, oOfen);
		CreateItemOnObject(sFoodResRef, oOfen);
		CreateItemOnObject(sFoodResRef, oOfen);
		FloatingTextStringOnCreature("Die Plätzchen sind fertig.", oPC, FALSE);
	}
}
// Brot
void bread(object oPC, object oOfen, int iAnzahl, int iBier, int iBrot, int iEi, int iFelspilz, int iFisch, int iFleisch, int iFruechte, int iHonigmilch, int iHonig, int iKaese, int iKnoblauch, int iMehl, int iMilch, int iSchmalz, int iSchnaps, int iWaldkraut, int iWasser, int iWein,
		   int iWurst) {
	string sFailure = "Das Rezept schlug fehl. Ihr müsst das ungenießbare Resultat fortwerfen.";

	//Bread (35%=1, 60%=2, 5%=3)
	//==========================
	//Brot                : Wasser + Mehl + Mehl
	//Knoblauchbrot       : Wasser + Mehl + Knoblauch
	//Zwergenbrot         : Wasser + Mehl + Bier
	//Honigbrot           : Wasser + Mehl + Honig
	//Schmalzbrot         : Wasser + Mehl + Schmalz
	//Hafenarbeiterzeche  : Wasser + Mehl + Schmalz + Wurst
	//Eiserne Ration      : Wasser + Mehl + Schmalz + Schmalz
	//Gewürzbrot          : Wasser + Mehl + Waldkraut
	string sFoodResRef = "";
	if ( iAnzahl == 3 && iMehl == 2 ) {
		sFoodResRef = "FOOD_COK_991";                                                                 //Brot
	} else if ( iAnzahl == 3 && iKnoblauch == 1 ) {
		sFoodResRef = "FOOD_COK_501_720";                                                                 //Knoblauchbrot
	} else if ( iAnzahl == 3 && iBier == 1 ) {
		sFoodResRef = "FOOD_COK_502_840";                                                                 //Zwergenbrot
	} else if ( iAnzahl == 3 && iHonig == 1 ) {
		sFoodResRef = "FOOD_COK_503_640";                                                                 //Honigbrot
	} else if ( iAnzahl == 3 && iSchmalz == 1 ) {
		sFoodResRef = "FOOD_COK_504_840";                                                                 //Schmalzbrot
	} else if ( iAnzahl == 4 && iSchmalz == 1 && iWurst == 1 ) {
		sFoodResRef = "FOOD_COK_992_480";                                                                 //Hafenarbeiterzeche
	} else if ( iAnzahl == 4 && iSchmalz == 2 ) {
		sFoodResRef = "FOOD_COK_1001";                                                                    //Eiserne Ration
	} else if ( iAnzahl == 3 && iWaldkraut == 1 ) {
		sFoodResRef = "FOOD_COK_505_840";                                                                 //Gewürzbrot
	}
	if ( sFoodResRef == "" ) {
		FloatingTextStringOnCreature(sFailure, oPC, FALSE);
	} else {
		int iW20 = d20();
		// Chance auf Anzahl Bread (35%=1, 60%=2, 5%=3)
		if ( iW20 > 19 ) CreateItemOnObject(sFoodResRef, oOfen);
		if ( iW20 >  7 ) CreateItemOnObject(sFoodResRef, oOfen);
		CreateItemOnObject(sFoodResRef, oOfen);
		FloatingTextStringOnCreature("Das Brot ist fertig.", oPC, FALSE);
	}

}
// Einfaches Essen
void eatsimple(object oPC, object oOfen, int iAnzahl, int iBier, int iBrot, int iEi, int iFelspilz, int iFisch, int iFleisch, int iFruechte, int iHonigmilch, int iHonig, int iKaese, int iKnoblauch, int iMehl, int iMilch, int iSchmalz, int iSchnaps, int iWaldkraut, int iWasser, int iWein,
			   int iWurst) {
	string sFailure = "Das Rezept schlug fehl. Ihr müsst das ungenießbare Resultat fortwerfen.";

	//EatSimple (100%=1)
	//==================
	//Gebratener Fisch      : Fisch
	//Gebratenes Fleisch    : Fleisch
	//Gebratenes Ei         : Ei
	//Honigmilch            : Honig + Milch
	//Käse                  : Milch + Milch
	//Süsse Fruechte        : Honig + Fruechte
	string sFoodResRef = "";
	if ( iAnzahl == 1 && iFisch == 1 ) {
		sFoodResRef = "FOOD_COK_998";                                                                         //Gebratener Fisch
	} else if ( iAnzahl == 1 && iFleisch == 1 ) {
		sFoodResRef = "FOOD_COK_002";                                                                         //Gebratenes Fleisch
	} else if ( iAnzahl == 1 && iEi == 1 ) {
		sFoodResRef = "FOOD_COK_996";                                                                         //Gebratenes Ei
	} else if ( iAnzahl == 2 && iHonig == 1 && iMilch == 1 ) {
		sFoodResRef = "FOOD_COK_1000";                                                                        //Honigmilch
	} else if ( iAnzahl == 2 && iMilch == 2 ) {
		sFoodResRef = "FOOD_COK_996_240";                                                                     //Käse
	} else if ( iAnzahl == 2 && iHonig == 1 && iFruechte == 1 ) {
		sFoodResRef = "FOOD_COK_987_480";                                                                     //Süsse Fruechte
	}
	if ( sFoodResRef == "" ) {
		FloatingTextStringOnCreature(sFailure, oPC, FALSE);
	} else {
		CreateItemOnObject(sFoodResRef, oOfen);
		FloatingTextStringOnCreature("Essen ist fertig.", oPC, FALSE);
	}
}
// Kleine Gerichte
void eatsmall(object oPC, object oOfen, int iAnzahl, int iBier, int iBrot, int iEi, int iFelspilz, int iFisch, int iFleisch, int iFruechte, int iHonigmilch, int iHonig, int iKaese, int iKnoblauch, int iMehl, int iMilch, int iSchmalz, int iSchnaps, int iWaldkraut, int iWasser, int iWein,
			  int iWurst) {
	string sFailure = "Das Rezept schlug fehl. Ihr müsst das ungenießbare Resultat fortwerfen.";

	//EatSmall (30%=1, 60%=2, 10%=3)
	//==============================
	//Rührei              : Ei + Ei + Ei + Schmalz
	//Rührei mit Speck    : Ei + Ei + Ei + Schmalz + Fleisch
	//Spiegelei           : Ei + Ei + Ei
	//Spätzle             : Ei + Mehl + Wasser
	//Käsespätzle         : Ei + Mehl + Wasser + Käse
	//Überbackener Käse   : Ei + Käse + Knoblauch + Waldkraut
	string sFoodResRef = "";
	if ( iAnzahl == 4 && iEi == 3 && iSchmalz == 1 ) {
		sFoodResRef = "FOOD_COK_601_360";                                                                     //Rührei
	} else if ( iAnzahl == 5 && iEi == 3 && iSchmalz == 1 && iFleisch == 1 ) {
		sFoodResRef = "FOOD_COK_602_480";                                                                     //Rührei mit Speck
	} else if ( iAnzahl == 3 && iEi == 3 ) {
		sFoodResRef = "FOOD_COK_603_360";                                                                     //Spiegelei
	} else if ( iAnzahl == 3 && iEi == 1 && iMehl == 1 && iWasser == 1 ) {
		sFoodResRef = "FOOD_COK_604_480";                                                                     //Spätzle
	} else if ( iAnzahl == 4 && iEi == 1 && iMehl == 1 && iWasser == 1 && iKaese == 1 ) {
		sFoodResRef = "FOOD_COK_604_480";                                                                     //Käsespätzle
	} else if ( iAnzahl == 4 && iKaese == 1 && iKnoblauch == 1 && iWaldkraut == 1 ) {
		sFoodResRef = "FOOD_COK_604_360";                                                                     //Überbackener Käse
	}
	if ( sFoodResRef == "" ) {
		FloatingTextStringOnCreature(sFailure, oPC, FALSE);
	} else {
		int iW20 = d20();
		// Chance auf Anzahl EatSmall (30%=1, 60%=2, 10%=3)
		if ( iW20 > 18 ) CreateItemOnObject(sFoodResRef, oOfen);
		if ( iW20 >  6 ) CreateItemOnObject(sFoodResRef, oOfen);
		CreateItemOnObject(sFoodResRef, oOfen);
		FloatingTextStringOnCreature("Essen ist fertig.", oPC, FALSE);
	}
}
// Mittlere Gerichte
void eatmedium(object oPC, object oOfen, int iAnzahl, int iBier, int iBrot, int iEi, int iFelspilz, int iFisch, int iFleisch, int iFruechte, int iHonigmilch, int iHonig, int iKaese, int iKnoblauch, int iMehl, int iMilch, int iSchmalz, int iSchnaps, int iWaldkraut, int iWasser, int iWein,
			   int iWurst) {
	string sFailure = "Das Rezept schlug fehl. Ihr müsst das ungenießbare Resultat fortwerfen.";

	//EatMedium (55%=1, 40%=2, 5%=3)
	//==============================
	//Panierter Karpfen   : Mehl + Ei + Fisch
	//Forelle blau        : Fisch + Wasser + Waldkraut
	//Paniertes Schnitzel : Mehl + Ei + Fleisch
	//Überbackene Scholle : Ei + Ei + Fisch
	//Überbackenes Fleisch: Ei + Ei + Fleisch
	//Wildschweinragout   : Fleisch + Wasser + Felspilz
	//Hirschragout in Rahm: Fleisch + Milch + Felspilz + Fruechte
	//Fisch in Weißwein   : Fisch + Wein + Waldkraut
	//Rehrücken in Rotwein: Fleisch + Wein + Waldkraut
	//Lachs & Kräutersosse: Fisch + Milch + Waldkraut
	//Krautwickel         : Fleisch + Waldkraut + Waldkraut
	//Hax'n mit Kraut     : Fleisch + Fleisch + Waldkraut + Waldkraut
	//Wurst               : Fleisch + Knoblauch + Waldkraut
	string sFoodResRef = "";
	if ( iAnzahl == 3 && iMehl == 1 && iEi == 1 && iFisch == 1 ) {
		sFoodResRef = "FOOD_COK_701_640";                                                                     //Panierter Karpfen
	} else if ( iAnzahl == 3 && iFisch == 1 && iWasser == 1 && iWaldkraut == 1 ) {
		sFoodResRef = "FOOD_COK_702_640";                                                                     //Forelle blau
	} else if ( iAnzahl == 3 && iMehl == 1 && iEi == 1 && iFleisch == 1 ) {
		sFoodResRef = "FOOD_COK_703_640";                                                                     //Paniertes Schnitzel
	} else if ( iAnzahl == 3 && iEi == 2 && iFisch == 1 ) {
		sFoodResRef = "FOOD_COK_704_640";                                                                     //Überbackene Scholle
	} else if ( iAnzahl == 3 && iEi == 2 && iFleisch == 1 ) {
		sFoodResRef = "FOOD_COK_705_640";                                                                     //Überbackenes Fleisch
	} else if ( iAnzahl == 3 && iFleisch == 1 && iWasser == 1 && iFelspilz == 1 ) {
		sFoodResRef = "FOOD_COK_706_840";                                                                     //Wildschweinragout
	} else if ( iAnzahl == 4 && iFleisch == 1 && iMilch == 1 && iFelspilz == 1 && iFruechte == 1 ) {
		sFoodResRef = "FOOD_COK_707_840";                                                                     //Hirschragout in Rahm
	} else if ( iAnzahl == 3 && iFisch == 1 && iWein == 1 && iWaldkraut == 1 ) {
		sFoodResRef = "FOOD_COK_708_640";                                                                     //Fisch in Weißwein
	} else if ( iAnzahl == 3 && iFleisch == 1 && iWein == 1 && iWaldkraut == 1 ) {
		sFoodResRef = "FOOD_COK_709_720";                                                                     //Rehrücken in Rotwein
	} else if ( iAnzahl == 3 && iFisch == 1 && iMilch == 1 && iWaldkraut == 1 ) {
		sFoodResRef = "FOOD_COK_710_640";                                                                     //Lachs & Kräutersosse
	} else if ( iAnzahl == 3 && iFleisch == 1 && iWaldkraut == 2 ) {
		sFoodResRef = "FOOD_COK_711_720";                                                                     //Krautwickel
	} else if ( iAnzahl == 4 && iFleisch == 2 && iWaldkraut == 2 ) {
		sFoodResRef = "FOOD_COK_712_960";                                                                     //Hax'n mit Kraut
	} else if ( iAnzahl == 3 && iFleisch == 1 && iKnoblauch == 1 && iWaldkraut == 1 ) {
		sFoodResRef = "FOOD_COK_993_480";                                                                     //Wurst
	}
	if ( sFoodResRef == "" ) {
		FloatingTextStringOnCreature(sFailure, oPC, FALSE);
	} else {
		int iW20 = d20();
		// Chance auf Anzahl EatMedium (55%=1, 40%=2, 5%=3)
		if ( iW20 > 19 ) CreateItemOnObject(sFoodResRef, oOfen);
		if ( iW20 > 11 ) CreateItemOnObject(sFoodResRef, oOfen);
		CreateItemOnObject(sFoodResRef, oOfen);
		FloatingTextStringOnCreature("Essen ist fertig.", oPC, FALSE);
	}
}



//Ofen während des Backvorgangs abschliessen und Feueranimation abspielen
void LockOfen(object oOfen) {
	vector vCooking = GetPosition(oOfen); //+ (AngleToVector(GetFacing(oOfen)) * 1.4f);
	location lCooking = Location(GetArea(oOfen), vCooking, GetFacing(oOfen));
	object oFlame = CreateObject(OBJECT_TYPE_PLACEABLE, "lc_flame", lCooking);
	object oSmoke = CreateObject(OBJECT_TYPE_PLACEABLE, "lc_smoke", lCooking);
	SetLocked(oOfen, TRUE);
	SetLocalObject(oOfen, "lc_flame", oFlame);
	SetLocalObject(oOfen, "lc_smoke", oSmoke);
}



//Ofen nach dem Backvorgang wieder aufschliessen und Feueranimation stoppen
void UnlockOfen(object oOfen) {
	SetLocked(oOfen, FALSE);
	DestroyObject(GetLocalObject(oOfen, "lc_flame"));
	DestroyObject(GetLocalObject(oOfen, "lc_smoke"));
}


//Hauptfunktion
void main() {
	ClearAllActions();
	//Variablen deklarieren
	object oOfen = OBJECT_SELF;
	object oPC = GetLastUsedBy();
	object oZutat = GetFirstItemInInventory(oOfen);

	// Es gibt 2 Arten von Kochstellen:
	//   1 - Feuerstelle (für Suppen und Braten z.B.)
	//   2 - Ofen (für Backwerk)
	// Hierfür wird eine int Variable der Kochstelle (iCookPlace) abgefragt
	// und auf binäre (!) Verknüpfung geachtet.
	int iCookPlace = GetLocalInt(OBJECT_SELF, "iCookPlace");

	// Anzahl verwendeter Einzel-Zutaten:
	int iBier       = 0;
	int iBrot       = 0;
	int iEi         = 0;
	int iFelspilz   = 0;
	int iFisch      = 0;
	int iFleisch    = 0;
	int iFruechte   = 0;
	int iHonigmilch = 0;
	int iHonig      = 0;
	int iKaese      = 0;
	int iKnoblauch  = 0;
	int iMehl       = 0;
	int iMilch      = 0;
	int iSchmalz    = 0;
	int iSchnaps    = 0;
	int iWaldkraut  = 0;
	int iWasser     = 0;
	int iWein       = 0;
	int iWurst      = 0;
	// Gesamtanzahl der Zutaten
	int iAnzahl     = 0;


	//Gegenstände im Ofen identifizieren und zählen
	while ( GetIsObjectValid(oZutat) ) {
		string sTag = GetTag(oZutat);

		if (       sTag == "NW_IT_MPOTION021"
			|| sTag == "FOOD_LIQ_994_060" ) {
			iBier++;
		} else if ( sTag == "FOOD_COK_991_960" ) {
			iBrot++;
		} else if ( sTag == "FOOD_RAW_996_120" ) {
			iEi++;
		} else if ( sTag == "Felspilz" ) {
			iFelspilz++;
		} else if ( sTag == "FOOD_RAW_998_480" ) {
			iFisch++;
		} else if ( sTag == "FOOD_RAW_002_480" ) {
			iFleisch++;
		} else if ( sTag == "FOOD_COK_003_480" ) {
			iFruechte++;
		} else if ( sTag == "FOOD_LIQ_x00_060" ) {
			iHonigmilch++;
			//Gibt eine leere Milchflasche ins PC Inv zurück
			CreateItemOnObject("Milkbottle_empty", oPC);
		} else if ( sTag == "FOOD_COK_990_020" ) {
			iHonig++;
		} else if ( sTag == "FOOD_COK_996_600" ) {
			iKaese++;
		} else if ( sTag == "Knoblauchknolle" ) {
			iKnoblauch++;
		} else if ( sTag == "Mehl" ) {
			iMehl++;
		} else if ( sTag == "FOOD_LIQ_997_060" ) {
			iMilch++;
			//Gibt eine leere Milchflasche ins PC Inv zurück
			CreateItemOnObject("Milkbottle_empty", oPC);
		} else if ( sTag == "FOOD_RAW_001_120"
				   || sTag == "Goblinfett" ) {
			iSchmalz++;
		} else if ( sTag == "NW_IT_MPOTION022" ) {
			iSchnaps++;
		} else if ( sTag == "Waldkraut" ) {
			iWaldkraut++;
		} else if ( sTag == "FOOD_LIQ_000_060" ) {
			iWasser++;
			//Gibt eine leere Wasserflasche ins PC Inv zurück
			CreateItemOnObject("waterbot_empty", oPC);
		} else if ( sTag == "NW_IT_MPOTION023"
				   || sTag == "FOOD_LIQ_995_060" ) {
			iWein++;
		} else if ( sTag == "FOOD_COK_993_480" ) {
			iWurst++;
		}
		iAnzahl += 1;

		// Jeder Gegestand, der in den Ofen gelegt wird, wird zerstört, unabhängig davon,
		// ob gebacken werden kann oder nicht
		DestroyObject(oZutat);
		oZutat = GetNextItemInInventory(oOfen);
	}

	//Wenn etwas reingelegt wurde, dann fange an zu kochen/backen
	if ( iAnzahl > 0 ) {
		// Kochzeiten und Kochart-Emotes festlegen
		float fEatSmall  = 30.0;
		string sEatSmall  = "Ihr gebt die Zutaten in die Pfanne und bratet sie kurz an.";
		float fEatSimple = 60.0;
		string sEatSimple =
			"Alles wurde bereitgestellt und köchelt. Euch bleibt nun nichts weiter als auf das Endergebnis zu warten.";
		float fSoup      = 105.0;
		string sSoup      =
			"Ihr gebt die Zutaten alle in den Topf und lasst das Ganze nun eine Weile köcheln.";
		float fEatMedium = 120.0;
		string sEatMedium =
			"Die Zutaten auf dem Kochfeuer zubereitend, lasst ihr, hier und da mit Gewürzen verfeinernd, langsam ein feines Mahl entstehen.";

		float fCookies   = 20.0;
		string sCookies   =
			"Den Teig in allerlei schöne Formen gebracht, schiebt ihr das Keksblech in den Ofen.";
		float fPancakes  = 30.0;
		string sPancakes  =
			"In der Pfanne breitet sich der Teig gut und langsam aus als ihr ihn reingießt. Nun heißt es kurz abwarten und rechtzeitig wenden.";
		float fBread     = 60.0;
		string sBread     =
			"Das Brot wird in den Ofen geschoben, wo es langsam an knackiger Form und krosser Farbe gewinnt.";
		float fCake      = 90.0;
		string sCake      = "Ihr schiebt das Backwerk in den Ofen und müsst nun abwarten.";


		// Wenn 2x Wasser verwendet wurde ist es eine Suppe (Kochstelle)
		if ( iWasser == 2 && iCookPlace & 1 ) {
			//Soups (25%=1, 50%=2, 25%=3)
			//===========================
			//Biersuppe           : Wasser + Wasser + Bier + Bier + Brot
			//Brotsuppe           : Wasser + Wasser + Brot + Brot
			//Eiersuppe           : Wasser + Wasser + Ei + Ei + Ei
			//Knoblauchsuppe      : Wasser + Wasser + Knoblauch + Knoblauch + Schmalz
			//Mehlsuppe           : Wasser + Wasser + Mehl + Mehl
			//Pilzragout          : Wasser + Wasser + Felspilz + Felspilz + Schmalz
			//Krautsuppe          : Wasser + Wasser + Waldkraut + Waldkraut + Waldkraut
			//Kräutercreme        : Wasser + Wasser + Milch + Waldkraut
			//Fischsuppe          : Wasser + Wasser + Fisch + Fisch + Waldkraut
			//Gulaschsuppe        : Wasser + Wasser + Fleisch + Fleisch + Knoblauch
			//Eintopf             : Wasser + Wasser + Waldkraut + Wurst + Felspilz + Knoblauch

			FloatingTextStringOnCreature(sSoup, oPC, FALSE);
			//Feuerstelle/Ofen abschliessen
			LockOfen(oOfen);
			//Backenfunktion aufrufen
			DelayCommand(fSoup, soup(oPC, oOfen, iAnzahl, iBier, iBrot, iEi, iFelspilz, iFisch, iFleisch,
					iFruechte, iHonigmilch, iHonig, iKaese, iKnoblauch, iMehl, iMilch, iSchmalz, iSchnaps,
					iWaldkraut,
					iWasser, iWein, iWurst));
			//Ofen wieder aufschliessen
			DelayCommand(fSoup - 2, UnlockOfen(oOfen));

		} else if ( iMilch == 1 && iHonigmilch == 1 && iEi >= 2 && iMehl >= 1 && iCookPlace & 2 ) {
			// Wenn 1x Milch, 1x Honigmilch, min. 2x Ei und mindestens 1x Mehl, dann ist es ein Kuchen (Backofen)

			//Cakes (45%=1, 55%=2)
			//====================
			//Kuchen              : Milch + Honigmilch + Ei + Ei + Mehl
			//Honigkuchen         : Milch + Honigmilch + Ei + Ei + Mehl + Honig
			//Marmorkuchen        : Milch + Honigmilch + Ei + Ei + Mehl + Ei
			//Streusselkuchen     : Milch + Honigmilch + Ei + Ei + Mehl + Mehl
			//Fruechtekuchen      : Milch + Honigmilch + Ei + Ei + Mehl + Fruechte
			//Grumbel's Kuchen    : Milch + Honigmilch + Ei + Ei + Mehl + Wein
			//Lotti's Kuchen      : Milch + Honigmilch + Ei + Ei + Mehl + Schnaps

			FloatingTextStringOnCreature(sCake, oPC, FALSE);
			//Feuerstelle/Ofen abschliessen
			LockOfen(oOfen);
			//Backenfunktion aufrufen
			DelayCommand(fCake, cake(oPC, oOfen, iAnzahl, iBier, iBrot, iEi, iFelspilz, iFisch, iFleisch,
					iFruechte,
					iHonigmilch, iHonig, iKaese, iKnoblauch, iMehl, iMilch, iSchmalz,
					iSchnaps, iWaldkraut, iWasser, iWein, iWurst));
			//Ofen wieder aufschliessen
			DelayCommand(fCake - 2, UnlockOfen(oOfen));
		} else if ( iMilch == 1 && iEi == 1 && iMehl == 1 && ( iCookPlace & 2 || iCookPlace & 1 ) ) {
			// Wenn 1x Milch, 1x Ei und 1x Mehl, dann ist es ein Pfannkuchen (Kochstelle & Backofen)

			//Pancakes (10%=1, 70%=2, 15%=3, 5%=4)
			//====================================
			//Pfannkuchen         : Milch + Ei + Mehl
			//Pfannkuchen & Sirup : Milch + Ei + Mehl + Honig
			//HinPfannkuchen      : Milch + Ei + Mehl + Honig + Schmalz
			//Arme Ritter         : Milch + Ei + Mehl + Honigmilch
			//Schmalzkringel      : Milch + Ei + Mehl + Schmalz
			//Kaiserschmarrn      : Milch + Ei + Mehl + Fruechte

			FloatingTextStringOnCreature(sPancakes, oPC, FALSE);
			//Feuerstelle/Ofen abschliessen
			LockOfen(oOfen);
			//Backenfunktion aufrufen
			DelayCommand(fPancakes, pancakes(oPC, oOfen, iAnzahl, iBier, iBrot, iEi, iFelspilz, iFisch,
					iFleisch, iFruechte,
					iHonigmilch, iHonig, iKaese, iKnoblauch, iMehl, iMilch, iSchmalz,
					iSchnaps, iWaldkraut, iWasser, iWein, iWurst));
			//Ofen wieder aufschliessen
			DelayCommand(fPancakes - 2, UnlockOfen(oOfen));
		} else if ( iHonigmilch == 1 && iEi == 1 && iMehl == 1 && iCookPlace & 2 ) {
			// Wenn 1x Honigmilch, 1x Ei und 1x Mehl, dann ist es ein Plätzchen (Backofen)

			//Cookies (5%=3, 15%=4, 30%=5, 30%=6, 15%=7, 5%=8)
			//================================================
			//Mürbeteig-Kekse     : Honigmilch + Ei + Mehl
			//Butterkeks          : Honigmilch + Ei + Mehl + Milch + Schmalz
			//Honigsplitter          : Honigmilch + Ei + Mehl + Honig
			//Pfefferkuchen       : Honigmilch + Ei + Mehl + Waldkraut
			//Marmeladenplätzchen : Honigmilch + Ei + Mehl + Fruechte
			//Rumkugeln           : Honigmilch + Ei + Mehl + Schnaps

			FloatingTextStringOnCreature(sCookies, oPC, FALSE);
			//Feuerstelle/Ofen abschliessen
			LockOfen(oOfen);
			//Backenfunktion aufrufen
			DelayCommand(fCookies, cookies(oPC, oOfen, iAnzahl, iBier, iBrot, iEi, iFelspilz, iFisch,
					iFleisch, iFruechte,
					iHonigmilch, iHonig, iKaese, iKnoblauch, iMehl, iMilch, iSchmalz,
					iSchnaps, iWaldkraut, iWasser, iWein, iWurst));
			//Ofen wieder aufschliessen
			DelayCommand(fCookies - 2, UnlockOfen(oOfen));

		} else if ( iWasser == 1 && iMehl >= 1 && iCookPlace & 2 ) {
			// Wenn 1x Wasser und min. 1x Mehl, dann ist es ein Brot (Backofen)

			//Bread (35%=1, 60%=2, 5%=3)
			//==========================
			//Brot                : Wasser + Mehl + Mehl
			//Knoblauchbrot       : Wasser + Mehl + Knoblauch
			//Zwergenbrot         : Wasser + Mehl + Bier
			//Honigbrot           : Wasser + Mehl + Honig
			//Schmalzbrot         : Wasser + Mehl + Schmalz
			//Hafenarbeiterzeche  : Wasser + Mehl + Schmalz + Wurst
			//Eiserne Ration      : Wasser + Mehl + Schmalz + Schmalz
			//Gewürzbrot          : Wasser + Mehl + Waldkraut

			FloatingTextStringOnCreature(sBread, oPC, FALSE);
			//Feuerstelle/Ofen abschliessen
			LockOfen(oOfen);
			//Backenfunktion aufrufen
			DelayCommand(fBread, bread(oPC, oOfen, iAnzahl, iBier, iBrot, iEi, iFelspilz, iFisch, iFleisch,
					iFruechte,
					iHonigmilch, iHonig, iKaese, iKnoblauch, iMehl, iMilch, iSchmalz,
					iSchnaps, iWaldkraut, iWasser, iWein, iWurst));
			//Ofen wieder aufschliessen
			DelayCommand(fBread - 2, UnlockOfen(oOfen));
		} else if ( ( iAnzahl == 1 || iAnzahl == 2 ) && ( iCookPlace & 2 || iCookPlace & 1 ) ) {
			// Wenn Zutaten gleich oder weniger als 2 sind, dann ist es einfachstes Essen (Kochstelle & Backofen)

			//EatSimple (100%=1)
			//==================
			//Gebratener Fisch    : Fisch
			//Gebratenes Fleisch  : Fleisch
			//Gebratenes Ei       : Ei
			//Honigmilch          : Honig + Milch
			//Käse                : Milch + Milch
			//Süsse Fruechte      : Honig + Fruechte

			FloatingTextStringOnCreature(sEatSimple, oPC, FALSE);
			//Feuerstelle/Ofen abschliessen
			LockOfen(oOfen);
			//Backenfunktion aufrufen
			DelayCommand(fEatSimple, eatsimple(oPC, oOfen, iAnzahl, iBier, iBrot, iEi, iFelspilz, iFisch,
					iFleisch, iFruechte,
					iHonigmilch, iHonig, iKaese, iKnoblauch, iMehl, iMilch, iSchmalz,
					iSchnaps, iWaldkraut, iWasser, iWein, iWurst));
			//Ofen wieder aufschliessen
			DelayCommand(fEatSimple - 2, UnlockOfen(oOfen));
		} else if ( iWasser == 1 && iMehl >= 1 && iCookPlace & 1 ) {
			// Wenn 3x Ei
			// ODER 1x Ei + 1x Mehl + 1x Wasser
			// ODER 1x Ei + 1x Knoblauch + 1x Waldkraut,
			// dann ist es eine leichte Mahlzeit ( Kochstelle )

			//EatSmall (30%=1, 60%=2, 10%=3)
			//==============================
			//Rührei              : Ei + Ei + Ei + Schmalz
			//Rührei mit Speck    : Ei + Ei + Ei + Schmalz + Fleisch
			//Spiegelei           : Ei + Ei + Ei
			//Spätzle             : Ei + Mehl + Wasser
			//Käsespätzle         : Ei + Mehl + Wasser + Käse
			//Überbackener Käse   : Ei + Käse + Knoblauch + Waldkraut

			FloatingTextStringOnCreature(sEatSmall, oPC, FALSE);
			//Feuerstelle/Ofen abschliessen
			LockOfen(oOfen);
			//Backenfunktion aufrufen
			DelayCommand(fEatSmall, eatsmall(oPC, oOfen, iAnzahl, iBier, iBrot, iEi, iFelspilz, iFisch,
					iFleisch, iFruechte,
					iHonigmilch, iHonig, iKaese, iKnoblauch, iMehl, iMilch, iSchmalz,
					iSchnaps, iWaldkraut, iWasser, iWein, iWurst));
			//Ofen wieder aufschliessen
			DelayCommand(fEatSmall - 2, UnlockOfen(oOfen));
		} else if ( iCookPlace & 1 ) {
			// Wenn es sich nicht einordnen lässt, dann ist es vll ein Gericht aus folgender Liste (Kochstelle)

			//EatMedium (55%=1, 40%=2, 5%=3)
			//==============================
			//Panierter Karpfen   : Fisch + Mehl + Ei
			//Forelle blau        : Fisch + Wasser + Waldkraut
			//Paniertes Schnitzel : Fleisch + Mehl + Ei
			//Überbackene Scholle : Fisch + Ei + Ei
			//Überbackenes Fleisch: Fleisch + Ei + Ei
			//Wildschweinragout   : Fleisch + Wasser + Felspilz
			//Hirschragout in Rahm: Fleisch + Milch + Felspilz + Fruechte
			//Fisch in Weißwein   : Fisch + Wein + Waldkraut
			//Rehrücken in Rotwein: Fleisch + Wein + Waldkraut
			//Lachs & Kräutersosse: Fisch + Milch + Waldkraut
			//Krautwickel         : Fleisch + Waldkraut + Waldkraut
			//Hax'n mit Kraut     : Fleisch + Fleisch + Waldkraut + Waldkraut
			//Wurst               : Fleisch + Knoblauch + Waldkraut

			FloatingTextStringOnCreature(sEatMedium, oPC, FALSE);
			//Feuerstelle/Ofen abschliessen
			LockOfen(oOfen);
			//Backenfunktion aufrufen
			DelayCommand(fEatMedium, eatmedium(oPC, oOfen, iAnzahl, iBier, iBrot, iEi, iFelspilz, iFisch,
					iFleisch, iFruechte,
					iHonigmilch, iHonig, iKaese, iKnoblauch, iMehl, iMilch, iSchmalz,
					iSchnaps, iWaldkraut, iWasser, iWein, iWurst));
			//Ofen wieder aufschliessen
			DelayCommand(fEatMedium - 2, UnlockOfen(oOfen));
		} else {
			FloatingTextStringOnCreature(
				"Als ihr versucht das Essen zu bereiten geht euch zu spät auf das für euer Rezept dies nicht die richtige Stelle scheint. Die Zutaten sind leider verloren.",
				oPC, FALSE);
		}
	}
}

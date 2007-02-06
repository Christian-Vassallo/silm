// Feuerwerk-Projekt (C) SnakeTS, 2003
/*
 * Dieses Script gehoert in das OnUsed-Event eines benutzbaren, platzierbaren
 * Objekts.
 * Damit es ausserdem funktioniert, muessen Sie ein platzierbares Objekt mit dem
 * Namen "feuerwerk" (Gross- und Kleinschreibung beachten) erstellen und dieses
 * sowohl mit dem Attribut 'Handlung' als auch mit dem Attribut 'Benutzbar'
 * versehen. Ausserdem sollte es das Aussehen eines unsichtbaren Objekts haben
 * (also unsichtbar erscheinen).
 * Script vom 11.08.2003
 * Geändert am 31.12.2004
 */
void main() {
	// Erforderliche Objekte
	object oStart = OBJECT_SELF;
	object oArea = GetArea(oStart);
	object oMittelpunkt = oStart;
	// Visuelle Effekte
	effect eGeschoss = EffectVisualEffect(VFX_IMP_MIRV);
	effect eGeschossPfeil = EffectVisualEffect(VFX_IMP_MIRV);
	effect eStartEffect = EffectVisualEffect(VFX_FNF_SUMMON_GATE);
	effect eStartFlimmern = EffectVisualEffect(VFX_DUR_ELEMENTAL_SHIELD);
	effect eExplosion = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_1);
	// Gesammtdauer des Feuerwerks
	// Aendern sie diese Werte nur, wenn sie wissen, was sie tun und mit den
	// Delay-Zeiten von NWN vertraut sind!
	float fFeuerwerksdauer = 28.0;
	float fStartzeit = 12.0;
	// Anzahl der Raketen & der Dauer
	// Diese Einstellung koennen Sie setzen, wie sie wollen, jedoch ist dann
	// auch eine Anpassung von 'fFeuerwerksdauer' notwendig!
	int iWiederholungen = 60;
	// Interne Zwecke
	int iCounter = 0;
	// Mittelpunktsvektor
	vector vMittelpunkt = GetPosition(oMittelpunkt);
	// Folgender Code ist umstaendlich; es gibt eine Verbesserte Version, die
	// jedoch nicht veroeffentlicht wird (und ca. 80 Zeilen kuerzer ist)
	// Kreisvektoren (gerundet)
	vector v1 = Vector(vMittelpunkt.x, vMittelpunkt.y + 10.0, vMittelpunkt.z + 5.0);
	vector v2 = Vector(vMittelpunkt.x + 7.0, vMittelpunkt.y + 7.0, vMittelpunkt.z + 1.0); // +7 +7
	vector v3 = Vector(vMittelpunkt.x + 10.0, vMittelpunkt.y, vMittelpunkt.z + 5.0);
	vector v4 = Vector(vMittelpunkt.x + 7.0, vMittelpunkt.y - 7.0, vMittelpunkt.z + 1.0); // +7 -7
	vector v5 = Vector(vMittelpunkt.x, vMittelpunkt.y - 10.0, vMittelpunkt.z + 5.0);
	vector v6 = Vector(vMittelpunkt.x - 7.0, vMittelpunkt.y - 7.0, vMittelpunkt.z + 1.0); // -7 -7
	vector v7 = Vector(vMittelpunkt.x - 10.0, vMittelpunkt.y, vMittelpunkt.z + 5.0);
	vector v8 = Vector(vMittelpunkt.x - 7.0, vMittelpunkt.y + 7.0, vMittelpunkt.z + 1.0); // -7 +7
	// Kreispunkte mit Ausrichtung zur Mitte
	location l1 = Location(oArea, v1, 270.0);
	location l2 = Location(oArea, v2, 225.0);
	location l3 = Location(oArea, v3, 180.0);
	location l4 = Location(oArea, v4, 135.0);
	location l5 = Location(oArea, v5, 90.0);
	location l6 = Location(oArea, v6, 45.0);
	location l7 = Location(oArea, v7, 0.0);
	location l8 = Location(oArea, v8, 315.0);
	// "feuerwerk" ist ein platzierbares, benutzbares, unsichtbares Objekt,
	// welches von ihnen erstellt werden muss!!!
	// Objekte der Kreispunkte mit Ausrichtung zur Mitte
	object o1 = CreateObject(OBJECT_TYPE_PLACEABLE, "feuerwerk", l1, FALSE);
	object o2 = CreateObject(OBJECT_TYPE_PLACEABLE, "feuerwerk", l2, FALSE);
	object o3 = CreateObject(OBJECT_TYPE_PLACEABLE, "feuerwerk", l3, FALSE);
	object o4 = CreateObject(OBJECT_TYPE_PLACEABLE, "feuerwerk", l4, FALSE);
	object o5 = CreateObject(OBJECT_TYPE_PLACEABLE, "feuerwerk", l5, FALSE);
	object o6 = CreateObject(OBJECT_TYPE_PLACEABLE, "feuerwerk", l6, FALSE);
	object o7 = CreateObject(OBJECT_TYPE_PLACEABLE, "feuerwerk", l7, FALSE);
	object o8 = CreateObject(OBJECT_TYPE_PLACEABLE, "feuerwerk", l8, FALSE);
	// Feuerwerk initialisieren
	DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eStartEffect, oStart));
	DelayCommand(5.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplosion, oStart));
	DelayCommand(5.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eStartFlimmern, oStart, fFeuerwerksdauer));
	// 1. Masseneffekt (Geschoss)
	DelayCommand(6.0, AssignCommand(oStart, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGeschoss, o1)));
	DelayCommand(6.0, AssignCommand(oStart, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGeschoss, o2)));
	DelayCommand(6.0, AssignCommand(oStart, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGeschoss, o3)));
	DelayCommand(6.0, AssignCommand(oStart, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGeschoss, o4)));
	DelayCommand(6.0, AssignCommand(oStart, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGeschoss, o5)));
	DelayCommand(6.0, AssignCommand(oStart, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGeschoss, o6)));
	DelayCommand(6.0, AssignCommand(oStart, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGeschoss, o7)));
	DelayCommand(6.0, AssignCommand(oStart, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGeschoss, o8)));
	// Folgende Effekte koennen auch auskommentiert werden
	// 1. Masseneffekt (Explosion)
	DelayCommand(7.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplosion, o1));
	DelayCommand(7.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplosion, o2));
	DelayCommand(7.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplosion, o3));
	DelayCommand(7.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplosion, o4));
	DelayCommand(7.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplosion, o5));
	DelayCommand(7.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplosion, o6));
	DelayCommand(7.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplosion, o7));
	DelayCommand(7.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplosion, o8));
	// 2. Masseneffekt (Geschoss)
	DelayCommand(9.2, AssignCommand(oStart, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGeschoss, o1)));
	DelayCommand(8.2, AssignCommand(oStart, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGeschoss, o2)));
	DelayCommand(9.6, AssignCommand(oStart, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGeschoss, o3)));
	DelayCommand(8.6, AssignCommand(oStart, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGeschoss, o4)));
	DelayCommand(9.0, AssignCommand(oStart, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGeschoss, o5)));
	DelayCommand(8.4, AssignCommand(oStart, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGeschoss, o6)));
	DelayCommand(8.8, AssignCommand(oStart, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGeschoss, o7)));
	DelayCommand(9.4, AssignCommand(oStart, ApplyEffectToObject(DURATION_TYPE_INSTANT, eGeschoss, o8)));
	// 2. Masseneffekt (Explosion)
	DelayCommand(10.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplosion, o1));
	DelayCommand(9.2, ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplosion, o2));
	DelayCommand(10.6, ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplosion, o3));
	DelayCommand(9.6, ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplosion, o4));
	DelayCommand(10.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplosion, o5));
	DelayCommand(9.4, ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplosion, o6));
	DelayCommand(9.8, ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplosion, o7));
	DelayCommand(10.4, ApplyEffectToObject(DURATION_TYPE_INSTANT, eExplosion, o8));
	// Ab hier sollte nichts mehr geaendert werden!!!
	// Beginn der Raketen
	while ( iCounter < iWiederholungen ) {
		int iAbstandx = 20;
		int iAbstandy = 20;
		int iAbstandz = 7;
		int iFarbe1 = Random(5);
		float frAbstandx1 = IntToFloat(Random(iAbstandx));
		float frAbstandy1 = IntToFloat(Random(iAbstandy));
		float frAbstandz1 = IntToFloat(Random(iAbstandz));
		float fDistanz1 = sqrt(IntToFloat(iAbstandx * iAbstandx) +
							  IntToFloat(iAbstandy * iAbstandy) + IntToFloat(iAbstandz * iAbstandz));
		float fZeit1 = fDistanz1 / 27;
		float irx1 = vMittelpunkt.x + frAbstandx1 - ( IntToFloat(iAbstandx) / 2.0 );
		float iry1 = vMittelpunkt.y + frAbstandy1 - ( IntToFloat(iAbstandy) / 2.0 );
		float irz1 = vMittelpunkt.z + frAbstandz1;
		vector vr1 = Vector(irx1, iry1, irz1);
		location lr1 = Location(oArea, vr1, 0.0);
		effect eFarbe1;
		switch ( iFarbe1 ) {
			case 0:
				{
					eFarbe1 = EffectVisualEffect(VFX_IMP_ACID_L);
					break;
				}
			case 1:
				{
					eFarbe1 = EffectVisualEffect(VFX_IMP_FLAME_M);
					break;
				}
			case 2:
				{
					eFarbe1 = EffectVisualEffect(VFX_IMP_FROST_L);
					break;
				}
			case 3:
				{
					eFarbe1 = EffectVisualEffect(VFX_IMP_POISON_L);
					break;
				}
			case 4:
				{
					eFarbe1 = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
					break;
				}
		}

		object or1 = CreateObject(OBJECT_TYPE_PLACEABLE, "feuerwerk", lr1, FALSE);
		DelayCommand(fStartzeit, AssignCommand(oStart, ApplyEffectToObject(DURATION_TYPE_INSTANT,
					eGeschossPfeil, or1)));
		DelayCommand(fStartzeit + fZeit1, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFarbe1, lr1));
		DelayCommand(fStartzeit, DestroyObject(or1, 0.25));
		fStartzeit = fStartzeit + 0.25;
		iCounter++;
	}
	// Objekte der Kreispunkte entfernen
	DestroyObject(o1, fFeuerwerksdauer);
	DestroyObject(o2, fFeuerwerksdauer);
	DestroyObject(o3, fFeuerwerksdauer);
	DestroyObject(o4, fFeuerwerksdauer);
	DestroyObject(o5, fFeuerwerksdauer);
	DestroyObject(o6, fFeuerwerksdauer);
	DestroyObject(o7, fFeuerwerksdauer);
	DestroyObject(o8, fFeuerwerksdauer);
	// Ausloeser-Objekt entfernen (kann auch auskommentiert werden)
	DelayCommand(fFeuerwerksdauer + 9.0, DestroyObject(OBJECT_SELF));
}

// Explosive Runes
#include "inc_cdb"

void main() {
	object oPC = OBJECT_SELF;

	object oPaper = GetSpellTargetObject();
	int nDC = GetSpellSaveDC(); // gets the DC required to save against the effects of the spell
	int nLevel = GetCasterLevel(oPC); // gets the level the PC cast the spell as

	location lPC = GetLocation(oPC);

	location lPaper = GetLocation(oPaper);

	if ( !GetIsObjectValid(GetAreaFromLocation(lPaper)) )
		lPaper = GetLocation(oPC);

	if ( GetTag(oPaper) != "c_paper" ) {
		FloatingTextStringOnCreature("Nur beschreibbares Pergament kann mit Explosive Runen belegt werden.",
			oPC, 0);
		return;
	}

	//if (GetLocalInt(oPaper, "explosive_runes")) {
	// FloatingTextStringOnCreature("Die Explosive Runen auf diesem Dokument leuchten kurz auf.", oPC, 0);
	//return;
	//}

	if ( GetPlotFlag(oPaper) ) {
		FloatingTextStringOnCreature("Plot-Gegenstaende koennen nicht verzaubert werden.", oPC, 0);
		return;
	}


	if ( !GetLocalInt(oPaper, "explosive_runes") ) {
		int nCID = GetCharacterID(oPC);

		SetLocalInt(oPaper, "explosive_runes", 1);
		SetLocalInt(oPaper, "explosive_runes_level", nLevel);
		SetLocalInt(oPaper, "explosive_runes_dc", 25 + nLevel);

		SetLocalInt(oPaper, "explosive_runes_cid_0", nCID);
		Floaty("Die Runen erkennen " + GetName(oPC) + " an.", oPC, 1);

		int i = 1;
		object oI = GetFirstObjectInShape(SHAPE_SPHERE, 4.0, lPC, TRUE, OBJECT_TYPE_CREATURE);
		while ( GetIsObjectValid(oI) ) {
			if ( GetIsPC(oI) && !GetIsDM(oI) ) {
				nCID = GetCharacterID(oI);
				Floaty("Die Runen erkennen " + GetName(oI) + " an.", oPC, 1);
				SetLocalInt(oPaper, "explosive_runes_cid_" + IntToString(i), nCID);
				ApplyEffectToObject(DTI, EffectVisualEffect(72), oI); //Knock
				i++;
			}
			oI = GetNextObjectInShape(SHAPE_SPHERE, 4.0, lPC, TRUE, OBJECT_TYPE_CREATURE);
		}
	}

	FloatingTextStringOnCreature("Ihr schreibt Explosive Runen auf dieses Dokument.", oPC, 0);

	// Yes.  This fails when its done in someones inventory.  I don't care.
	DelayCommand(0.1, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(
				VFX_COM_BLOOD_SPARK_LARGE, 1), lPaper));
	DelayCommand(0.2, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(
				VFX_COM_BLOOD_SPARK_LARGE, 1), lPaper));
	DelayCommand(0.3, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(
				VFX_COM_BLOOD_SPARK_LARGE, 1), lPaper));
	DelayCommand(0.4, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(
				VFX_COM_BLOOD_SPARK_LARGE, 1), lPaper));
	DelayCommand(0.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(
				VFX_COM_BLOOD_SPARK_LARGE, 1), lPaper));
	DelayCommand(0.6, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(
				VFX_COM_BLOOD_SPARK_LARGE, 1), lPaper));
	DelayCommand(0.7, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(
				VFX_COM_BLOOD_SPARK_LARGE, 1), lPaper));
	DelayCommand(0.8, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(
				VFX_COM_BLOOD_SPARK_LARGE, 1), lPaper));
}

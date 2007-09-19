#include "_gen"
#include "x0_i0_treasure"

void main() {
	object oPC = GetLastAttacker();
	object oTool = GetLastWeaponUsed(oPC);

	if ( GetTag(oTool) == "pickaxe" || GetTag(oTool) == "pickaxesmall" ) {
		int bSmall = GetTag(oTool) == "pickaxesmall";

		string sRessource = GetLocalString(OBJECT_SELF, "ressource");

		int nLadung = GetLocalInt(OBJECT_SELF, "ladung");

		if ( GetCurrentHitPoints() < 500 && ( GetMaxHitPoints() == 0 || nLadung == 0 ) ) {
			SendMessageToAllDMs("Warnung: HP = 0 oder Stein hat keine Ladung gesetzt: " +
				GetTag(OBJECT_SELF) + " " + LocationToStringPrintable(GetLocation(OBJECT_SELF)));
			return;
		}

		int nRate = GetLocalInt(OBJECT_SELF, "rate");
		if ( !nRate ) {
			nRate = GetMaxHitPoints() / nLadung;
			SetLocalInt(OBJECT_SELF, "rate", nRate);
		}

		if ( GetIsDM(oPC) )
			SendMessageToPC(oPC, "HP: " +
				IntToString(GetCurrentHitPoints()) +
				", Rate: " +
				IntToString(nRate) +
				", Ladung: " +
				IntToString(nLadung) + ", HP/Rate: " + IntToString(GetCurrentHitPoints() / nRate));

		if ( nRate == 0 ) {
			SendMessageToAllDMs("Warnung: Stein hat keine Rate gesetzt: " +
				GetTag(OBJECT_SELF) + " " + LocationToStringPrintable(GetLocation(OBJECT_SELF)));
			return;
		}

		while ( GetCurrentHitPoints() / nRate <= nLadung ) {
			CreateItemOnObject(sRessource, oPC, 1);
			audit("mine", oPC, audit_fields("resref", sRessource, "area", GetTag(GetArea(oPC))), "mining");
			nLadung--;
		}
		
		GenerateGemChainTreasure(OBJECT_SELF, oPC);

		SetLocalInt(OBJECT_SELF, "ladung", nLadung);

	} else if ( !GetIsObjectValid(oTool) ) {
		FloatingTextStringOnCreature("Aua!", oPC, 1);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d2()), oPC);

	} else {

		FloatingTextStringOnCreature("Mit diesem .. Werkzeug .. laesst sich hier wahrlich nichts abbauen.",
			oPC);

	}
}

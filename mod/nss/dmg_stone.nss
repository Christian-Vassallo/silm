#include "_gen"

void main() {
	object oPC = GetLastAttacker();
	object oTool = GetLastWeaponUsed(oPC);

	if ( GetTag(oTool) == "pickaxe" || GetTag(oTool) == "pickaxesmall" ) {
		int bSmall = GetTag(oTool) == "pickaxesmall";

		string sRessource = GetLocalString(OBJECT_SELF, "ressource");

		string sGemSet = GetLocalString(OBJECT_SELF, "res_gem");
		int nGemPerMil = GetLocalInt(OBJECT_SELF, "res_gem_per_mil");

		string sGemSet2 = GetLocalString(OBJECT_SELF, "res_gem_2");
		int nGemPerMil2 = GetLocalInt(OBJECT_SELF, "res_gem_per_mil_2");

		string sGemSet3 = GetLocalString(OBJECT_SELF, "res_gem_3");
		int nGemPerMil3 = GetLocalInt(OBJECT_SELF, "res_gem_per_mil_3");

		string sGemSet4 = GetLocalString(OBJECT_SELF, "res_gem_4");
		int nGemPerMil4 = GetLocalInt(OBJECT_SELF, "res_gem_per_mil_4");

		string sGemSet5 = GetLocalString(OBJECT_SELF, "res_gem_5");
		int nGemPerMil5 = GetLocalInt(OBJECT_SELF, "res_gem_per_mil_5");

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

		int bNoMoreGems = 0;
		int bNoMoreGems2 = 0;
		int bNoMoreGems3 = 0;
		int bNoMoreGems4 = 0;
		int bNoMoreGems5 = 0;

		while ( GetCurrentHitPoints() / nRate <= nLadung ) {
			CreateItemOnObject(sRessource, oPC, 1);
			nLadung--;

			if ( !bNoMoreGems && sGemSet != "" && ( 1 + Random(1000000) ) <= nGemPerMil ) {
				CreateItemOnObject(sGemSet, oPC, 1);
				//bNoMoreGems = 1;
			}
			if ( !bNoMoreGems2 && sGemSet2 != "" && ( 1 + Random(1000000) ) <= nGemPerMil2 ) {
				CreateItemOnObject(sGemSet2, oPC, 1);
				//bNoMoreGems2 = 1;
			}
			if ( !bNoMoreGems3 && sGemSet3 != "" && ( 1 + Random(1000000) ) <= nGemPerMil3 ) {
				CreateItemOnObject(sGemSet3, oPC, 1);
				//bNoMoreGems3 = 1;
			}
			if ( !bNoMoreGems4 && sGemSet4 != "" && ( 1 + Random(1000000) ) <= nGemPerMil4 ) {
				CreateItemOnObject(sGemSet4, oPC, 1);
				//bNoMoreGems4 = 1;
			}
			if ( !bNoMoreGems5 && sGemSet5 != "" && ( 1 + Random(1000000) ) <= nGemPerMil5 ) {
				CreateItemOnObject(sGemSet5, oPC, 1);
				//bNoMoreGems5 = 1;
			}
		}


		SetLocalInt(OBJECT_SELF, "ladung", nLadung);

	} else if ( !GetIsObjectValid(oTool) ) {

		FloatingTextStringOnCreature("Aua!", oPC, 1);
		ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(d2()), oPC);

	} else {

		FloatingTextStringOnCreature("Mit diesem .. Werkzeug .. laesst sich hier wahrlich nichts abbauen.",
			oPC);

	}
}

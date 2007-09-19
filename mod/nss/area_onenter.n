#include "inc_subr_area"
#include "inc_areaclean"

void main() {
	object oArea = OBJECT_SELF;
	object oPC = GetEnteringObject();
	string sAreaType = GetLocalString(oArea, "AreaType");
	if ( !GetIsObjectValid(oPC) ) return;

	// Innenmaps
	if ( GetIsAreaInterior(oArea) ) {
		// Einstellungen fuer Subrasseneinstellungen im Gebiet
		if ( sAreaType == "Hoehle" ) {
			SR_Enter_Area(GetEnteringObject(), SR_AREA_UNDERGROUND | SR_AREA_NATURAL);
		} else {
			SR_Enter_Area(GetEnteringObject(), SR_AREA_INSIDE);
		}
	}
	// Aussenmaps
	else {
		// Einstellungen fuer Subrasseneinstellungen im Gebiet
		if ( sAreaType == "Aussen" ) {
			SR_Enter_Area(GetEnteringObject(), SR_AREA_DAYLIGHT | SR_AREA_OPENSPACE);
		} else if ( sAreaType == "Wald" ) {
			SR_Enter_Area(GetEnteringObject(), SR_AREA_DAYLIGHT | SR_AREA_NATURAL);
		} else {
			SR_Enter_Area(GetEnteringObject(), SR_AREA_DAYLIGHT | SR_AREA_NATURAL | SR_AREA_OPENSPACE);
		}
		// Wetteraktualisierung wenn jemand eine Map betritt
		/*
		 * int iClimate = GetLocalInt(OBJECT_SELF, "weather");
		 * int iOldWeather = GetWeather(OBJECT_SELF);
		 * int iWeather = GetAreaWeather(iClimate);
		 * if(iOldWeather != iWeather)
		 * {
		 * 	SetWeather(OBJECT_SELF,iWeather);
		 * }   */

	}
	int nCutScene = GetLocalInt(oPC, "CutScene");
	if ( nCutScene == TRUE ) {}
	Cl_Areaentered();
	ExecuteScript("_area_enter", OBJECT_SELF);
}

#include "inc_subr_area"
#include "inc_areaclean"


void main() {
	/*int iClimate = GetLocalInt(OBJECT_SELF, "weather");
	 * int iOldWeather = GetWeather(OBJECT_SELF);
	 * int iWeather = GetAreaWeather(iClimate);
	 * if(iOldWeather != iWeather)
	 * {
	 * SetWeather(OBJECT_SELF,iWeather);
	 * }
	 */

	if ( !GetIsObjectValid(GetEnteringObject()) ) return;

	Cl_Areaentered();
	SR_Enter_Area(GetEnteringObject(), SR_AREA_DAYLIGHT | SR_AREA_OPENSPACE);
	ExecuteScript("_area_enter", OBJECT_SELF);
}

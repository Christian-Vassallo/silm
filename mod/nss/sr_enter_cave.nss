#include "inc_subr_area"
#include "inc_areaclean"

void main() {
	if ( !GetIsObjectValid(GetEnteringObject()) ) return;

	Cl_Areaentered();
	SR_Enter_Area(GetEnteringObject(), SR_AREA_UNDERGROUND | SR_AREA_NATURAL);
	ExecuteScript("_area_enter", OBJECT_SELF);

}

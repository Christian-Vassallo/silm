#include "_gen"
#include "inc_mnx"

void main() {
	object oPC = OBJECT_SELF;

	struct mnxRet r = mnxRun(oPC, "slogan");

	if ( !r.error )
		DelayCommand(10.0, FloatingTextStringOnCreature(r.ret, oPC, FALSE));
}

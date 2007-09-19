#include "inc_doors"

void main() {
	object oPC = GetClickingObject();
	AssignCommand(oPC, JumpToObject(GetTransitionTarget(OBJECT_SELF)));
}

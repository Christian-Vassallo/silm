#include "inc_blackboard"

void main() {
	object oPC = GetLocalObject(OBJECT_SELF, "ConvList_PC");
	DeleteLocalInt(oPC, "bb_sel");
	object oBlackBoard = GetLocalObject(OBJECT_SELF, "bb_board");

	MakeBlackBoardDialog(oPC, oBlackBoard);
}

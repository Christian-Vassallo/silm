#include "inc_blackboard"

void main() {
	object oPC = GetLocalObject(OBJECT_SELF, "ConvList_PC");
	object oBlackBoard = GetLocalObject(OBJECT_SELF, "bb_board");
	ClearMenuLevel(oPC, "bb", 0);

	MakeBlackBoardDialog(oPC, oBlackBoard);
}

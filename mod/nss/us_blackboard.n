#include "_gen"
#include "inc_blackboard"




void main() {
	object oPC = GetLastUsedBy();
	if ( !GetIsBlackBoard(OBJECT_SELF) ) {
		ToPC("Fehler: Keine BB-ID gesetzt.", oPC);
		return;
	}

	int nCount = GetBlackBoardEntryCount();

	SetLocalObject(oPC, "bb_board", OBJECT_SELF);


	MakeBlackBoardDialog(oPC, OBJECT_SELF);

	ActionStartConversation(oPC, "list_select", 1, 0);
}

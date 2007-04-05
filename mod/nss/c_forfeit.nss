#include "c_const"
#include "c_db"

void main() {
	object oGM = OBJECT_SELF;
	object oPlayer = GetPCSpeaker();
	if (GetLocalObject(oGM, "oWhitePlayer") == oPlayer)
		SaveChessGame(oGM, RESULT_BLACK);
	else
		SaveChessGame(oGM, RESULT_WHITE);
}


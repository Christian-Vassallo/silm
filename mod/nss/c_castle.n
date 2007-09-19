#include "c_chessinc"

void main() {
	int nPosition, nTurn, nKingPos, nKingPos1, nKingPos2, nTemp, nCheckMate;
	object oGM, oKing;

	oGM = GetNearestObjectByTag("c_gamemaster");
	nTurn = GetLocalInt(oGM, "Turn");

	nPosition = GetLocalInt(OBJECT_SELF, "nPosition");
	if ( ( nPosition & 7 ) == 0 ) {
		nKingPos = nPosition + 4;
		nKingPos1 = nPosition + 3;
		nKingPos2 = nPosition + 2;
	} else {
		nKingPos = nPosition - 3;
		nKingPos1 = nPosition - 2;
		nKingPos2 = nPosition - 1;
	}

	if ( CheckForCheck(nKingPos, nTurn) ) ActionSpeakString("Nein, Rochade aus Schach heraus geht nicht.");
	else {
		SetIntArray(oGM, "nSquare", nKingPos, 0);
		SetIntArray(oGM, "nSquare", nKingPos1, 6 * nTurn);
		if ( CheckForCheck(nKingPos1, nTurn) ) {
			SetIntArray(oGM, "nSquare", nKingPos, 6 * nTurn);
			SetIntArray(oGM, "nSquare", nKingPos1, 0);
			ActionSpeakString("Nein, Rochade durch Schach hindurch geht nicht.");
		} else {
			SetIntArray(oGM, "nSquare", nKingPos1, 0);
			SetIntArray(oGM, "nSquare", nKingPos2, 6 * nTurn);
			if ( CheckForCheck(nKingPos2, nTurn) ) {
				SetIntArray(oGM, "nSquare", nKingPos, 6 * nTurn);
				SetIntArray(oGM, "nSquare", nKingPos2, 0);
				ActionSpeakString("Nein, Rochade in Schach hinein geht nicht.");
			} else {
				SetIntArray(oGM, "nSquare", nPosition, 0);
				SetIntArray(oGM, "nSquare", nKingPos1, 2 * nTurn);
				oKing = GetObjectArray(oGM, "oSquare", nKingPos);
				AssignCommand(oKing, ActionJumpToLocation(GetLocationArray(oGM, "lSquare", nKingPos2)));
				SetObjectArray(oGM, "oSquare", nKingPos, oGM);
				SetObjectArray(oGM, "oSquare", nKingPos2, oKing);
				SetLocalInt(oKing, "nPosition", nKingPos2);

				ActionJumpToLocation(GetLocationArray(oGM, "lSquare", nKingPos1));
				SetObjectArray(oGM, "oSquare", nPosition, oGM);
				SetObjectArray(oGM, "oSquare", nKingPos1, OBJECT_SELF);
				SetLocalInt(OBJECT_SELF, "nPosition", nKingPos1);

				int nCheck = FALSE,
					nEndGame = FALSE;

				nTurn = nTurn * ( -1 );
				SetLocalInt(oGM, "Turn", nTurn);
				nCheckMate = CheckForCheckMate();
				if ( nCheckMate == 2 ) {
					SetLocalInt(oGM, "GameResult", RESULT_DRAW);
					Announce("Patt!");
					nEndGame = 1;
					SetLocalInt(oGM, "GameState", 3);
				} else if ( nCheckMate == 1 ) {
					SetLocalInt(oGM, "GameResult", GetLocalInt(oGM, "Turn") == -1 ? RESULT_BLACK : RESULT_WHITE);
					Announce("Schachmatt!");
					nEndGame = 1;
					SetLocalInt(oGM, "GameState", 3);
				} else {
					//find opposing king
					nKingPos = 0;
					while ( TRUE ) {
						nTemp = GetIntArray(oGM, "nSquare", nKingPos);
						if ( nTemp == nTurn * 6 ) break;
						nKingPos++;
					}
					if ( nCheck = CheckForCheck(nKingPos, nTurn) ) SpeakString("Schach!", TALKVOLUME_TALK);
				}

				GameLog2("O-O" + ( nEndGame ? "#" : ( nCheck ? "+" : "" ) ));

			}
		}
	}


}

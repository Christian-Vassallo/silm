#include "inc_mysql"
#include "c_const"
#include "inc_cdb"

const string CHESS_TABLE = "chess_games";

const int
	RESULT_DRAW = 1,
	RESULT_WHITE = 2,
	RESULT_BLACK = 3;

void SaveChessGame(object oGameMaster, int result) {
	int nStart = GetLocalInt(oGameMaster, "GameStart");
	int variant = GetLocalInt(oGameMaster, "nVariant");
	string sLog = GetLocalString(oGameMaster, "GameLog");
	object oWhite = GetLocalObject(oGameMaster, "oWhitePlayer");
	object oBlack = GetLocalObject(oGameMaster, "oWhitePlayer");
	int white = GetAccountID(oWhite);
	int black = GetAccountID(oBlack);

	SQLQuery("insert into " + CHESS_TABLE + 
		" (white, black, result, variant, start, end, log)" + 
		" values(" +
		IntToString(white) + ", " +
		IntToString(black) + ", '" + 
		(result == RESULT_WHITE ? "white" : 
			result == RESULT_BLACK ? "black" : 
			"draw"
		) + "', '" + 
		(variant == VARIANT_STANDARD ? "standard" : 
			variant == VARIANT_PAWNS ? "pawns" : 
			variant == VARIANT_FISCHERRANDOM ? "fischerrandom" : 
			"displacement"
		) + "', " +		
		IntToString(nStart) + ", now(), " +
		SQLEscape(sLog) + 
		");"
	);
}

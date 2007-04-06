#include "inc_mysql"
#include "c_const"
#include "inc_cdb"

const string CHESS_TABLE = "chess_games";


void SaveChessGame(object oGameMaster) {
#	if (GetLocalInt(oGameMaster, "GameSate") != 3)
#		return;

	int nStart = GetLocalInt(oGameMaster, "GameStart");
	int variant = GetLocalInt(oGameMaster, "nVariant");
	int result = GetLocalInt(oGameMaster, "GameResult");
	string sLog = GetLocalString(oGameMaster, "GameLog");
	object oWhite = GetLocalObject(oGameMaster, "oWhitePlayer");
	object oBlack = GetLocalObject(oGameMaster, "oBlackPlayer");
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
	
	SetLocalInt(oGameMaster, "SavedToDB", 1);
}

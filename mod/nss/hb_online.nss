#include "_gen"
#include "inc_cdb"
#include "inc_mysql"

void main() {

	SQLQuery("truncate table online;");
	object oPC = GetFirstPC();

	// Noones here, dont even bother!
	if ( !GetIsObjectValid(oPC) )
		return;

	string q =
		"insert into online (`aid`, `cid`, `account`, `character`, `dm`, `area`, `x`, `y`, `z`, `f`) values";

	while ( GetIsObjectValid(oPC) ) {
		vector p = GetPosition(oPC);
		float f = GetFacing(oPC);
		string
		sAID = IntToString(GetAccountID(oPC)),
		sCID = IntToString(GetCharacterID(oPC)),
		sAccount = SQLEscape(GetPCName(oPC)),
		sName = SQLEscape(GetName(oPC)),
		sIsDM = IntToString(GetIsDM(oPC)),
		sArea = SQLEscape(GetResRef(GetArea(oPC))),
		sX = FloatToString(p.x),
		sY = FloatToString(p.y),
		sZ = FloatToString(p.z),
		sF = FloatToString(f);


		q += "(" +
			 sAID +
			 "," +
			 sCID +
			 "," +
			 sAccount +
			 "," + sName + "," + sIsDM + "," + sArea + "," + sX + "," + sY + "," + sZ + "," + sF + "),";

		oPC = GetNextPC();
	}

	q = GetStringLeft(q, GetStringLength(q) - 1); // chomp off last ,
	q += ";";
	SQLQuery(q);
}

#include "inc_pc_data"
#include "inc_pc_mnxnotify"
#include "inc_pgsql"
#include "inc_currency"
#include "inc_xp_handling"
#include "inc_persist"
#include "inc_horse"

void main() {

	if ( !GetIsPC(OBJECT_SELF) )
		return;

	load_player(OBJECT_SELF);

	notify_pc_login(OBJECT_SELF);

	DelayCommand(300.0, save_player(OBJECT_SELF, TRUE));


	if ( GetIsRidingHorse(OBJECT_SELF) ) {
		struct Rideable r = GetRideable(OBJECT_SELF);
		SetLocalString(OBJECT_SELF, "horse_name", r.name);
	}


/*	if ( !GetLocalInt(OBJECT_SELF, "first_login") && !GetIsDM(OBJECT_SELF) ) {
		
		SQLQuery("select `AreaTag`,X,Y,Z from tab_chars where Char_Name = '" +
			sCharName + "' and GSA_Account = '" + sPlayerName + "' limit 1;");
		if ( SQLFetch() ) {
			string sArea = SQLGetData(1);
			vector v;
			v.x = StringToFloat(SQLGetData(2));
			v.y = StringToFloat(SQLGetData(3));
			v.z = StringToFloat(SQLGetData(4));

			object oA = GetObjectByTag(sArea);
			if ( GetIsObjectValid(oA) ) {
				location ll = Location(oA, v, 0.0);
				object ot = OBJECT_SELF;
				AssignCommand(ot, DelayCommand(4.0, JumpToLocation(ll)));
			}
		}
		SetLocalInt(OBJECT_SELF, "first_login", 1);
	}
*/
}



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
}



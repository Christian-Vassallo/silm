#include "inc_decay"
#include "inc_persist"


//Workaround for Time-Stop-Bug: Resync clocks with core clock
//Once every game hour is said to be enough
void _ClockFix() {
	int iHour = GetTimeHour();
	int iMinute = GetTimeMinute();
	int iSecond = GetTimeSecond();
	int iMillisecond = GetTimeMillisecond();
	SetTime(iHour, iMinute, iSecond, iMillisecond);
}

void main() {
	int iHour = GetTimeHour();

	object oMod = GetModule();
	object oPC = GetFirstPC();

	ExecuteScript("hb_online", oMod);
	
	ExecuteScript("hb_time_xp", oMod);


	while ( GetIsObjectValid(oPC) ) {
		if ( !GetIsDM(oPC) ) {
			//Placeholder for player-specific scripts/routines which are to be
			//executed every heartbeat
			//ExecuteScript("hb_hunger",oPC);
			ExecuteScript("hb_running", oPC);
			ExecuteScript("hb_persistency", oPC);
		}
		oPC = GetNextPC();
	}

	//Placeholder for module-wide scripts/routines which are to be
	//executed every heartbeat

	if ( iHour != GetLocalInt(oMod, "Module_Hour") ) {
		_ClockFix();
		SetLocalInt(oMod, "Module_Hour", iHour);

		SetLegacyPersistentInt(oMod, "TIME_YEAR", GetCalendarYear());
		SetLegacyPersistentInt(oMod, "TIME_MONTH", GetCalendarMonth());
		SetLegacyPersistentInt(oMod, "TIME_DAY", GetCalendarDay());
		SetLegacyPersistentInt(oMod, "TIME_HOUR", iHour);

		//Place for scripts/routines which are to be executed once every
		//game hour
		ExecuteScript("hhb_subrace", oMod);
		ExecuteScript("hhb_mnx_temp", oMod);
	}
}

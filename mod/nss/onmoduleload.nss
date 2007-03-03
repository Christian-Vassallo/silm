#include "inc_mnx"
#include "_gen"
#include "inc_nwnx"
#include "inc_mysql"
#include "inc_persist"
#include "inc_pc_data"
#include "inc_chat"
#include "inc_chat_run"
#include "x2_inc_switches"
#include "_buildinfo"
#include "inc_setting"
void main() {
	object oMod = GetModule();
	int iHour, iDay, iMonth, iYear;


	SetMaxHenchmen(0xff);

	SetLocalString(GetModule(), "X2_S_UD_SPELLSCRIPT", "hook_spell");

	SetModuleSwitch(MODULE_SWITCH_ENABLE_CROSSAREA_WALKWAYPOINTS, TRUE);

	InitNWNX();
	SQLInit();
	ChatInit();
	mnxInit();

	RegisterAllCommands();

	ExecuteScript("_mod_load_cdb", GetModule());

	SQLQuery("truncate table `online`;");

	
	iYear = gvGetInt("t_year");
	iMonth = gvGetInt("t_month");
	iDay = gvGetInt("t_day");
	iHour = gvGetInt("t_hour");

	if ( !iYear )
		WriteTimestampedLogEntry("No time entry, starting with preset module time");
	else {
		WriteTimestampedLogEntry("Module time: " +
			IntToString(GetCalendarDay()) +
			". " + IntToString(GetCalendarMonth()) + ". " + IntToString(GetCalendarYear()));
		WriteTimestampedLogEntry("Restoring Date & Time: " +
			IntToString(iDay) + ". " + IntToString(iMonth) + ". " + IntToString(iYear) +
			" " + IntToString(iHour) + ":00");
		SetTime(iHour, 0, 0, 0);
		SetCalendar(iYear, 1, 1);
		if ( iMonth > 1 ) SetCalendar(iYear, iMonth, 1);
		if ( iDay > 1 ) SetCalendar(iYear, iMonth, iDay);
		WriteTimestampedLogEntry("Set module time to: " +
			IntToString(GetCalendarDay()) +
			". " + IntToString(GetCalendarMonth()) + ". " + IntToString(GetCalendarYear()));
	}

	// Global-Weather Setting
	//weather_setup();
	//weather_update();

	ExecuteScript("reg_subraces", OBJECT_SELF);
	WriteTimestampedLogEntry("Subraces initialized");
	ExecuteScript("reg_dispenser", OBJECT_SELF);
	WriteTimestampedLogEntry("Dispensers initialized");
	ExecuteScript("reg_spawn", OBJECT_SELF);
	WriteTimestampedLogEntry("Spawn system initialization in progress");
	ExecuteScript("reg_gods", OBJECT_SELF);
	WriteTimestampedLogEntry("God entries initialized");

	ExecuteScript("_events_register", OBJECT_SELF);

	mnxCommand("startup", REVISION);


	SetLocalInt(oMod, "tracking", 1);

	SetLocalInt(oMod, "startup_ts", GetUnixTimestamp());

	WriteTimestampedLogEntry("Module initialization done.");

	mnxCommand("startup", REVISION);
}

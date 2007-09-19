#include "_gen"
#include "inc_2dacache"

// Sets up an effect for the duration of eEffect.
// Stops reminding when eEffect gets removed.
void SetupReminder(object oRemindWho, string sReminderName, float fDuration, effect eEffect);


void DoRemind(object oRemindWho, string sReminderName, effect eEffect, int nSeconds);





void SetupReminder(object oRemindWho, string sReminderName, float fDuration, effect eEffect) {
	DoRemind(oRemindWho, sReminderName, eEffect, FloatToInt(fDuration));

	if ( fDuration > 3600.0 )
		DelayCommand(fDuration - 3600.0, DoRemind(oRemindWho, sReminderName, eEffect, 3600));
	if ( fDuration > 1200.0 )
		DelayCommand(fDuration - 1200.0, DoRemind(oRemindWho, sReminderName, eEffect, 1200));
	if ( fDuration > 600.0 )
		DelayCommand(fDuration - 600.0, DoRemind(oRemindWho, sReminderName, eEffect, 600));
	if ( fDuration > 120.0 )
		DelayCommand(fDuration - 120.0, DoRemind(oRemindWho, sReminderName, eEffect, 120));
	if ( fDuration > 60.0 )
		DelayCommand(fDuration - 60.0, DoRemind(oRemindWho, sReminderName, eEffect, 60));
	if ( fDuration > 30.0 )
		DelayCommand(fDuration - 30.0, DoRemind(oRemindWho, sReminderName, eEffect, 30));
	if ( fDuration > 15.0 )
		DelayCommand(fDuration - 15.0, DoRemind(oRemindWho, sReminderName, eEffect, 15));
	if ( fDuration > 5.0 )
		DelayCommand(fDuration - 5.0, DoRemind(oRemindWho, sReminderName, eEffect, 5));
}

void DoRemind(object oRemindWho, string sReminderName, effect eEffect, int nSeconds) {
	int nFound = 0;
	effect e = GetFirstEffect(oRemindWho);
	while ( GetIsEffectValid(e) ) {
		if ( e == eEffect ) {
			nFound = 1;
			break;
		}
		e = GetNextEffect(oRemindWho);
	}

	if ( nFound )
		SendMessageToPC(oRemindWho, "Eure Arkane " +
			sReminderName + " loest sich in " + SecondsToTimeDesc(nSeconds));
}




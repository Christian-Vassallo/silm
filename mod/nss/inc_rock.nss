// Checks de right Keyword
void CheckRockKeyword(object oPC, object oRock, string sKey);

void CheckRockKeyword(object oPC, object oRock, string sKey) {
	int nMatch = GetListenPatternNumber();
	if ( nMatch == 99 ) {
		string sText = GetMatchedSubstring(0);
		SendMessageToAllDMs(sText + " / " + sKey);
		if ( FindSubString(GetStringLowerCase(sText), GetStringLowerCase(sKey)) > -1 ) {
			AssignCommand(oRock, ActionSpeakString(
					"*Die Steine rollen etwas beiseite und geben einen kurzen Moment den Weg frei*",
					TALKVOLUME_TALK));
			AssignCommand(oPC, ActionJumpToLocation(GetLocation(GetObjectByTag(GetLocalString(oRock, "ziel")))));
		} else {
			AssignCommand(oRock, ActionSpeakString("*Der Stein fuehlt sich kalt an*", TALKVOLUME_TALK));
		}
	}
	SetListening(oRock, FALSE);
}

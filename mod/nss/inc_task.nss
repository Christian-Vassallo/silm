// Do Task by TaskID
void ExecuteTask(object oSubject);

// Returns the TaskID of the current Task
int GetCurrentTask(object oSubject);

// Returns the TaskID of the next Task
int GetTaskNumber(object oSubject);

// Returns the Time Delay between yet and the NextTask in Seconds
float GetTaskDelay(object oSubject);

void ExecuteTask(object oSubject) {
	int nTaskID = GetCurrentTask(oSubject);
	string sTask = GetLocalString(oSubject, "task" + IntToString(nTaskID));
	location lTask = GetLocation(GetObjectByTag("TP_" + GetTag(oSubject) + "_" + sTask));
	if ( GetDistanceBetweenLocations(lTask, GetLocation(oSubject)) > 2.0 ) {
		SendMessageToAllDMs("Gehe zu " + GetTag(GetObjectByTag("TP_" + GetTag(oSubject) + "_" + sTask)));
		AssignCommand(oSubject, ClearAllActions());
		AssignCommand(oSubject, ActionMoveToLocation(lTask));
		DelayCommand(30.0, ExecuteTask(oSubject));
	} else {
		float nDelay = GetTaskDelay(oSubject);
		if ( sTask == "work" ) {
			AssignCommand(oSubject, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, nDelay));
			SendMessageToAllDMs("arbeite " + FloatToString(nDelay) + " Seconds");
		} else if ( sTask == "rest" ) {
			AssignCommand(oSubject, ActionPlayAnimation(ANIMATION_LOOPING_SIT_CROSS, 1.0, nDelay));
			SendMessageToAllDMs("pause " + FloatToString(nDelay) + " Seconds");
		} else if ( sTask == "sleep" ) {
			AssignCommand(oSubject, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, nDelay));
			SendMessageToAllDMs("schlafe " + FloatToString(nDelay) + " Seconds");
		}
		SetLocalString(oSubject, "CurrentTask", sTask);
		DelayCommand(nDelay, ExecuteTask(oSubject));
	}
}

float GetTaskDelay(object oSubject) {
	int nCurrentTaskHour = GetLocalInt(oSubject, "taskhour" + IntToString(GetCurrentTask(oSubject)));
	int nNextTaskHour = GetLocalInt(oSubject, "taskhour" + IntToString(GetCurrentTask(oSubject) + 1));
	SendMessageToAllDMs("aktuelle TaskZeit: " +
		IntToString(nCurrentTaskHour) + " - naechste TaskZeit" + IntToString(nNextTaskHour));
	float nDelay;
	int nCurrentSec = ( GetTimeHour() * 3600 ) + ( GetTimeMinute() * 60 ) + GetTimeSecond();
	SendMessageToAllDMs("jetzt: " +
		IntToString(GetTimeHour()) +
		":" +
		IntToString(GetTimeMinute()) +
		":" + IntToString(GetTimeSecond()) + " - Zielstunde: " + IntToString(nNextTaskHour));
	int nNextSec = nNextTaskHour * 3600;
	if ( nNextSec > nCurrentSec ) {
		//next Event on the same Day
		nDelay = IntToFloat(( nNextSec - nCurrentSec ) / 4);
	} else {
		// next Event on the next Day
		nDelay = IntToFloat(( ( 86400 - nCurrentSec ) + nNextSec ) / 4);
	}
	return nDelay;
}

int GetCurrentTask(object oSubject) {
	int nHour = GetTimeHour();
	int nTaskHour = GetLocalInt(oSubject, "taskhour1");
	int nCurrentTaskID = 1;
	if ( nHour < nTaskHour ) {
		// last Task of day bevor
		nCurrentTaskID = GetTaskNumber(oSubject);
	} else {
		while ( nHour > nTaskHour ) {
			nCurrentTaskID++;
		}
	}
	SendMessageToAllDMs("aktueller Task: " + IntToString(nCurrentTaskID));
	return nCurrentTaskID;
}

int GetTaskNumber(object oSubject) {
	int nTask = 1;
	while ( GetLocalString(oSubject, "task" + IntToString(nTask + 1)) != "" ) {
		nTask++;
	}
	return nTask;
}

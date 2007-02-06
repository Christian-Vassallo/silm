#include "_mnx"
#include "_chat"


// Polls for new events on the mnx interface,
// executes them, and returns the number of
// actions performed.
int Poll();

void PollCommand(string sCommand);


int Poll() {
	struct mnxRet r;

	r = mnxCmd("pollcount");
	if ( r.error ) {
		return -1;
	}

	int count = StringToInt(r.ret);

	int i;
	for ( i = 0; i < count; i++ ) {
		r = mnxCmd("poll");
		if ( r.error ) {
			return 0 - i;
		}

		PollCommand(r.ret);
	}
	return count;
}


void PollCommand(string sCommand) {
	string
	sC = # 0,
	s1 = # 1,
	s2 = # 2;

	object oSender = GetObjectByTag("poll_sender");
	object oRecp;

	switch ( sC ) {
		case "msg":
			// msg
			oRecp = FindPlayerByName();

			SpeakToChannel(oSender, MSG_PRIVATE, s2, oRecp);
			break;
		default:
			sC = "PollEngine: Unknown Command: " + sC;
			WriteTimestampedLogEntry(sC);
			SendMessageToAllDMs(sC);
			break;
	}
}

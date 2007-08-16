const int
MSG_TALK = 1,
MSG_SHOUT = 2,
MSG_WHISPER = 3,
MSG_PRIVATE = 4,
MSG_SERVER = 5,
MSG_PARTY = 6,
MSG_SILENT_SHOUT = 13,
MSG_DM = 14,

MSG_MODE_DM = 16,

MODE_TALK = 1,
MODE_SHOUT = 2,
MODE_WHISPER = 4,
MODE_PRIVATE = 8,
MODE_PARTY = 16,
MODE_DM = 32,

MODE_DM_MODE = 64,       // This will be passed through to commands, but use GetIsDM() instead.
MODE_COMMAND = 128,     // this will NOT be filtered out either
MODE_FORCETALK = 256,      // this will NOT be filtered out either
MODE_TELEPATHICBOND = 512,
MODE_QUICKJUMP = 1024;

const int
MSG_TARGET_GLOBAL = -1,
MSG_TARGET_PRIVATE = 0;


const string
LIST_ITEM_NAME = "chatPC_",
PC_ID_NAME = "chatID";


// Makes oSender speak to oRecipient on nChannel = MSG_*.
void SpeakToChannel(object oSender, int nChannel, string sMessage, object oRecipient = OBJECT_INVALID);


// Returns the PC with the given player ID, or OBJECT_INVALID if invalid ..
object GetPC(int nID);

// Suppress the last chat message. ONLY usable
// in the chat script.
void Suppress(object oPC = OBJECT_SELF);

// Do not process the next incoming text message for object.
// = increment the chatlock counter for object.
int ChatLock(object oPC = OBJECT_SELF);

// Decremet the chatlock counter for oPC
int ChatLockCheck(object oPC = OBJECT_SELF);




void SpeakToChannel(object oSender, int nChannel, string sMessage, object oRecipient = OBJECT_INVALID) {
	if ( !GetIsObjectValid(oSender) )
		return;

	if ( FindSubString(sMessage, "¬") != -1 )
		return;

	if ( nChannel == MSG_PRIVATE && !GetIsObjectValid(oRecipient) )
		return;

	SetLocalString(oSender, "NWNX!CHAT!SPEAK", ObjectToString(oSender) +
		"¬" + ObjectToString(oRecipient) + "¬" + IntToString(nChannel) + "¬" + sMessage);
}


int ChatMsgToMode(int n) {
	switch ( n ) {
		case MSG_TALK:
			return MODE_TALK;

		case MSG_SHOUT:
			return MODE_SHOUT;

		case MSG_WHISPER:
			return MODE_WHISPER;

		case MSG_PRIVATE:
			return MODE_PRIVATE;

		case MSG_PARTY:
			return MODE_PARTY;

		case MSG_DM:
			return MODE_DM;

			// ignore this for now
		case MSG_SILENT_SHOUT:
			return 0;
	}

	SendMessageToAllDMs("[chathandler] Whoops, mode " + IntToString(n) + " not found. Bug!");
	return 0;
}



void ChatInit() {
	int i;
	object oMod = GetModule();
	// memory for chat text
	string sMemory;
	for ( i = 0; i < 8; i++ )  // reserve 8*128 bytes
		sMemory +=
			"................................................................................................................................";
	SetLocalString(oMod, "NWNX!INIT", "1");
	SetLocalString(oMod, "NWNX!CHAT!SPACER", sMemory);
}

string ChatGetSpacer() {
	return GetLocalString(GetModule(), "NWNX!CHAT!SPACER");
}

void ChatPCin(object oPC) {
	if ( !GetIsObjectValid(oPC) )
		return;

	object oMod = GetModule();
	SetLocalString(oPC, "NWNX!CHAT!GETID", ObjectToString(oPC) + "        ");
	string sID = GetLocalString(oPC, "NWNX!CHAT!GETID");
	int nID = StringToInt(sID);

	if ( nID != -1 ) {
		SetLocalObject(oMod, LIST_ITEM_NAME + sID, oPC);
		SetLocalInt(oPC, PC_ID_NAME, nID);
	}
	DeleteLocalString(oPC, "NWNX!CHAT!GETID");
}

void ChatPCout(object oPC) {
	if ( !GetIsObjectValid(oPC) )
		return;

	int nID = GetLocalInt(oPC, PC_ID_NAME);
	DeleteLocalInt(oPC, PC_ID_NAME);
	DeleteLocalObject(GetModule(), LIST_ITEM_NAME + IntToString(nID));
}


// helpers

object GetPC(int nID) {
	return GetLocalObject(GetModule(), LIST_ITEM_NAME + IntToString(nID));
}


void Suppress(object oPC = OBJECT_SELF) {
	SetLocalString(oPC, "NWNX!CHAT!SUPRESS", "1");
}

int ChatLock(object oPC = OBJECT_SELF) {

	int nL = GetLocalInt(oPC, "chat_lock");

	nL += 1;

	SetLocalInt(oPC, "chat_lock", nL);

	return nL;
}





int ChatLockCheck(object oPC = OBJECT_SELF) {

	int nL = GetLocalInt(oPC, "chat_lock");

	nL -= 1;

	if ( nL < 0 )
		nL = 0;

	SetLocalInt(oPC, "chat_lock", nL);

	return nL;
}

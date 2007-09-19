/*
 * By Bernard 'Elven' Stoeckner <elven@elven.de>
 * Licence: None/Private
 */
#include "_gen"

const string
MNX_IP = "127.0.0.1",
MNX_PORT = "2800",
MNX_SEND_COMMAND = "NWNX!MNX!SEND!RMNX!";

const string
MNX_BACKEND_ERROR =
	"The backend that gets to do the cool stuff went away, lurking in the pool together with the PostgreSQL database.  Please do try again later.";

const int
MNX_ERROR = 0,
MNX_SUCCESS = 1;

string
mnxReplyString = "",
mnxErrorString = "";


struct mnxRet {
	int error;
	string ret;
};

// Returns the result string on success, or
// #ERR# on failure.
// The error message can be retrieved via mnxGetError()
string mnxCommand(string command, string param = "", string param2 = "", string param3 = "", string param4 = "", string param5 = "", string param6 = "", string param7 = "",
				  string param8 = "");


// Use this.
struct mnxRet mnxCmd(string command, string param = "", string param2 = "", string param3 = "", string param4 = "", string param5 = "", string param6 = "", string param7 = "",
					 string param8 = "");

// Use this.
struct mnxRet mnxRun(object oPC, string command, string param = "", string param2 = "", string param3 = "", string param4 = "", string param5 = "", string param6 = "", string param7 = "",
					 string param8 = "");

// Returns true if the last transaction resulted in some error.
int mnxWasError();

// Sets a string.  Do not call this.
string mnxGetString(string sKey);

// Returns the state of the last transaction, which is
// either "success" or a descriptive error message.
string mnxGetError();


string mnxEscape(string sString);
string mnxDescape(string sString);


void mnxInit() {
	int i;
	string sMemory;

	for ( i = 0; i < 16; i++ )
		sMemory += "................................................................";
	//SetLocalString(GetModule(), "NWNX!INIT", "1");

	SetLocalString(GetModule(), "NWNX_buffer", sMemory);
	SetLocalString(GetModule(), "NWNX!MNX!OPEN!RMNX!", MNX_IP +
		":" + MNX_PORT + "                                ");
}

// Sends a Key or a Key/Value pair to the mNWNX plugin
// If no value is specified, NWNX_buffer will be sent to
// accept the value.
// returns: MNX_SUCCESS
//          MNX_ERROR
int mnxSetString(string sKey, string sValue = "", string mnxbuffer = "NWNX_buffer") {
	if ( sValue == "" ) {
		SetLocalString(GetModule(), MNX_SEND_COMMAND + sKey, GetLocalString(GetModule(), mnxbuffer));
	} else {
		SetLocalString(GetModule(), "NWNX!MNX!CMD!" + sKey, sValue);
	}
	return MNX_SUCCESS;
}


string mnxGetString(string sKey) {
	// query the plugin ...
	if ( mnxSetString(sKey) == MNX_ERROR )
		return "*** error ***";

	// check the return
	return GetLocalString(GetModule(), MNX_SEND_COMMAND + sKey);
}

void mnxKillString(string sKey) {
	// check the return
	DeleteLocalString(GetModule(), MNX_SEND_COMMAND + sKey);
}



// Retrieves the answer.
// Waits at most 300ms for the packet to arrive.
void mnxGetAnswer(string receipt, int retriesLeft = 6, float delay = 0.1f) {
	// Ask for the answer/result by sending the receipt
	int bFound = 1;
	mnxReplyString = mnxGetString("RECEIPT!" + receipt);
	//        SendMessageToPC(GetFirstPC(), "mnxGetAnswer(): mnxReplyString = "+mnxReplyString);

	if ( mnxReplyString == "UNAVAIL" ) {
		//            SendMessageToPC(GetFirstPC(), "mnxGetAnswer(): retrying");
		DelayCommand(delay, mnxGetAnswer(receipt, retriesLeft - 1, delay));
		bFound = 0;
	}
}


string mnxEscape(string sString) {
	if ( FindSubString(sString, "!") == -1 )  // not found
		return sString;

	int i;
	string sReturn = "";
	string sChar;

	// Loop over every character and replace special characters
	for ( i = 0; i < GetStringLength(sString); i++ ) {
		sChar = GetSubString(sString, i, 1);
		if ( sChar == "!" )
			sReturn += "#EXCL#";
		else
			sReturn += sChar;
	}
	return sReturn;
}

string mnxDescape(string sString) {
	if ( FindSubString(sString, "#EXCL#") == -1 ) {
		// not found
		//SendMessageToPC(GetFirstPC(), "Not descaped: "+sString);
		return sString;
	}

	int i;
	string sReturn = "";
	string sChar;

	// Loop over every character and replace special characters
	for ( i = 0; i < GetStringLength(sString); i++ ) {
		sChar = GetSubString(sString, i, 6);
		if ( sChar == "#EXCL#" ) {
			sReturn += "!";
			i += 5;
		} else
			sReturn += GetSubString(sString, i, 1);
	}
	//SendMessageToPC(GetFirstPC(), "Descaped to "+sReturn);
	return sReturn;
}

string mnxGetError() {
	return mnxErrorString;
}


int mnxWasError() {
	return mnxErrorString != "success";
}

string mnxCommand(string command, string param = "", string param2 = "", string param3 = "", string param4 = "", string param5 = "", string param6 = "", string param7 = "",
				  string param8 = "") {
	string str = mnxEscape(command);
	if ( param != "" )
		str += "!" + mnxEscape(param);
	if ( param2 != "" )
		str += "!" + mnxEscape(param2);
	if ( param3 != "" )
		str += "!" + mnxEscape(param3);
	if ( param4 != "" )
		str += "!" + mnxEscape(param4);
	if ( param5 != "" )
		str += "!" + mnxEscape(param5);
	if ( param6 != "" )
		str += "!" + mnxEscape(param6);
	if ( param7 != "" )
		str += "!" + mnxEscape(param7);
	if ( param8 != "" )
		str += "!" + mnxEscape(param8);

	string rcp = mnxGetString(str);

	mnxGetAnswer(rcp);

	if ( GetSubString(mnxReplyString, 0, 5) == "#ERR#" ) {
		mnxErrorString = GetSubString(mnxReplyString, 6, GetStringLength(mnxReplyString) - 5);
		return "#ERR#";

		// The backend's down
	} else if ( GetSubString(mnxReplyString, 0, 20) == "...................." ) {
		mnxErrorString = MNX_BACKEND_ERROR;
		return "#ERR#";
	} else {
		mnxErrorString = "success";
		//SendMessageToPC(GetFirstPC(), "Before descaping: "+mnxReplyString);
		return mnxDescape(mnxReplyString);
	}
}


struct mnxRet mnxCmd(string command, string param = "", string param2 = "", string param3 = "", string param4 = "", string param5 = "", string param6 = "", string param7 = "",
					 string param8 = "") {
	struct mnxRet r;

	r.ret = mnxCommand(command, param, param2, param3, param4, param5, param6, param7, param8);
	r.error = mnxWasError();
	if ( r.error )
		r.ret = mnxGetError();

	return r;
}


struct mnxRet mnxRun(object oPC, string command, string param = "", string param2 = "", string param3 = "", string param4 = "", string param5 = "", string param6 = "", string param7 = "",
					 string param8 = "") {
	struct mnxRet r;

	if ( GetIsPC(oPC) )
		mnxCommand("setpc", GetPCName(oPC), GetName(oPC), IntToString(GetLocalInt(oPC, "aid")), IntToString(
				GetLocalInt(oPC, "cid")));

	r.ret = mnxCommand(command, param, param2, param3, param4, param5, param6, param7, param8);
	r.error = mnxWasError();
	if ( r.error )
		r.ret = mnxGetError();

	return r;
}

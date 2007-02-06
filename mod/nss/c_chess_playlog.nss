#include "c_chessinc"

const int CHAR_PER_LINE = 150;

void main() {
	object oGM = OBJECT_SELF;
	string glog = GetLocalString(oGM, "GameLog");
	string n = "";
	int count = ( GetStringLength(glog) / CHAR_PER_LINE ) + 1;
	int i = 1;

	if ( 0 <= count ) {
		ActionSpeakString("Bisher kein Log vorhanden.");
		//return;
	}

	while ( GetStringLength(glog) > 0 ) {
		n = GetStringLeft(glog, CHAR_PER_LINE);
		glog = GetStringRight(glog, GetStringLength(glog) - CHAR_PER_LINE);
		ActionSpeakString(IntToString(i) + "/" + IntToString(count) + ": " + n);
		i += 1;
	}
}

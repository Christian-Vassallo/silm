//#################################################
//## Laesst NPCs sich auf den naechsten freien Stuhl setzen.
//## Der Stuhl braucht den Tag "CHAIR1"
//## ***tribute to 4byte aka Marcus***
//###################################################


void main() {
	int nNth = 1;
	object oStuhl = GetNearestObjectByTag("CHAIR1");
	while ( GetIsObjectValid(oStuhl) ) {
		if ( !GetIsObjectValid(GetSittingCreature(oStuhl)) ) {
			AssignCommand(OBJECT_SELF, ActionSit(oStuhl));
			break;
		}
		oStuhl = GetNearestObjectByTag("CHAIR1", OBJECT_SELF, ++nNth);
	}
}

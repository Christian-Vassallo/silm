///////////////////////////////////////////////////
//: FILE NAME: gb_loot_corps_ud
//: EVENT HANDLE: Corps Object UserDefined
//: FUNCTION: Empty inventory before distruction
///////////////////////////////////////////////////
//: CREATED BY: Glenn J. Berden aka Jassper
//: CREATED ON: 02/17/03
//: MODIFIED BY:
//: MODIFIED ON:
///////////////////////////////////////////////////
void main() {
	int nUser = GetUserDefinedEventNumber();
	if ( nUser == 110 ) {
		//Signal to auto cleanup
		ExecuteScript("gb_loot_corps_cl", OBJECT_SELF);
		DestroyObject(OBJECT_SELF);
	}
}

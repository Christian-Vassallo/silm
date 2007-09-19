///////////////////////////////////////////////////
//: FILE NAME: gb_loot_corps_oc
//: EVENT HANDLE: OnClose of the Corps Placeable
//: FUNCTION: To destroy itself and the corps
///////////////////////////////////////////////////
//: CREATED BY: Glenn J. Berden aka Jassper
//: CREATED ON: 01/21/03
//: MODIFIED BY:
//: MODIFIED ON:
///////////////////////////////////////////////////
void main() {
	if ( GetPlotFlag(OBJECT_SELF) ) return;

	if ( !GetIsObjectValid(GetFirstItemInInventory()) ) {
		DestroyObject(OBJECT_SELF);
		AssignCommand(GetLocalObject(OBJECT_SELF, "Body"), SetIsDestroyable(TRUE));
	}
}

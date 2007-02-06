// Ein Eichenholz wird innerhalb von 15 Sekunden in einen Holzbalken umgewandelt.
// Gibt man mehrere Eichenhlzer hinein landen alle bis auf eines wieder im Inventar.
// Somit kann nur jeweils eines gleichzeitig bearbeitet werden.

void UnlockSawbuck(object oSawbuck) {
	AssignCommand(oSawbuck, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
	SetLocked(oSawbuck, FALSE);
}

void LockSawbuck(object oSawbuck) {
	AssignCommand(oSawbuck, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
	SetLocked(oSawbuck, TRUE);
}

void _DoSawing(object oSawbuck) {
	CreateItemOnObject("bm_holzbalken", oSawbuck);
	UnlockSawbuck(oSawbuck);
}

void DoSawing(object oPC, object oSawbuck) {
	object oItm = GetFirstItemInInventory(oSawbuck);
	object oPC = GetLastClosedBy();
	int i;

	if ( GetTag(oItm) == "CS_MA20" ) {

		while ( GetIsObjectValid(oItm) ) {

			DestroyObject(oItm);
			oItm = GetNextItemInInventory(oSawbuck);
			i++;

		}

		while ( i > 1 ) {

			CreateItemOnObject("cs_ma20", oPC);
			i--;

		}

		LockSawbuck(oSawbuck);
		AssignCommand(oSawbuck, PlaySound("as_cv_sawing1"));
		DelayCommand(5.0f, AssignCommand(oSawbuck, PlaySound("as_cv_sawing2")));
		DelayCommand(11.0f, AssignCommand(oSawbuck, PlaySound("as_cv_sawing1")));
		DelayCommand(15.0f, _DoSawing(oSawbuck));

	}
}

void main() {
	if ( !GetIsObjectValid(GetFirstItemInInventory(OBJECT_SELF)) ) return;

	DoSawing(GetLastClosedBy(), OBJECT_SELF);
}

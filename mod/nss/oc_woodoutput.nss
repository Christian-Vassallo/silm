void UnlockWoodOutput(object oWoodOutput) {
	AssignCommand(oWoodOutput, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
	SetLocked(oWoodOutput, FALSE);
}

void LockWoodOutput(object oWoodOutput) {
	AssignCommand(oWoodOutput, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
	SetLocked(oWoodOutput, TRUE);
}

void _DoWoodOutput(object oWoodOutput) {
	CreateItemOnObject("cs_ma20", oWoodOutput);
	UnlockWoodOutput(oWoodOutput);
}

void DoWoodOutput(object oPC, object oWoodOutput) {
	object oItm = GetFirstItemInInventory(oWoodOutput);
	object oPC = GetLastClosedBy();
	int iNum;

	if ( GetTag(oItm) == "BM_Woodcredit" ) {

		while ( GetIsObjectValid(oItm) ) {

			DestroyObject(oItm);
			iNum += GetItemStackSize(oItm);
			oItm = GetNextItemInInventory(oWoodOutput);

		}

		if ( iNum > 1 ) {


			CreateItemOnObject("bm_woodcredit", oPC, iNum - 1);
			iNum = 0;

		}

		LockWoodOutput(oWoodOutput);
		AssignCommand(oWoodOutput, PlaySound("as_cv_woodframe1"));
		DelayCommand(3.0f, AssignCommand(oWoodOutput, PlaySound("as_cv_woodframe2")));
		DelayCommand(4.0f, _DoWoodOutput(oWoodOutput));

	}
}

void main() {
	if ( !GetIsObjectValid(GetFirstItemInInventory(OBJECT_SELF)) ) return;

	DoWoodOutput(GetLastClosedBy(), OBJECT_SELF);
}

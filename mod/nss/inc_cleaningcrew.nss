#include "_gen"
/* The cleaning crew */


void CleanAreaForItems(object oArea, int bRun = FALSE);


void CleanAreaForItems(object oArea, int bRun = FALSE) {
	if ( !bRun )
		DelayCommand(240.0, CleanAreaForItems(oArea, TRUE));

	else {
		return;
		/*
		 * if (GetAreaHasPlayers()) {
		 * 	// Reschedule for later
		 * 	return;
		 * }
		 *
		 * object oI = GetFirstObjectInArea(oArea);
		 *
		 * while (GetIsObjectValid(oI)) {
		 *
		 * 	if (OBJECT_TYPE_ITEM == GetObjectType(oI)) {
		 *
		 * 	}
		 *
		 * 	oI = GetNextObjectInArea(oArea);
		 * } */
	}
}

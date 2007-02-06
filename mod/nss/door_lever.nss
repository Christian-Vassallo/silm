/*
 * Lever to open the nearest door
 */

void main() {
	object oDoor = GetNearestObject(OBJECT_TYPE_DOOR);
	ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE);
	SetLocked(oDoor, FALSE);
	ActionOpenDoor(oDoor);
	DelayCommand(2.0f, ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
}

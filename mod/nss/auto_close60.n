void CloseLock() {
	ActionCloseDoor(OBJECT_SELF);
	//SetLocked(OBJECT_SELF,TRUE);
}

void main() {
	DelayCommand(60.0f, CloseLock());
}

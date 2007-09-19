void CloseLock() {
	ActionCloseDoor(OBJECT_SELF);
	SetLocked(OBJECT_SELF, TRUE);
}

void main() {
	DelayCommand(5.0f, CloseLock());
}

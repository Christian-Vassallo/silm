// Tuer wird geschlossen, aber nicht VERschlossen.

void CloseDoor() {
	ActionCloseDoor(OBJECT_SELF);
}

void main() {
	DelayCommand(10.0f, CloseDoor());
}

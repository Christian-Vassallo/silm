void main() {
	object attacker = GetLocalObject(OBJECT_SELF, "attacker");
	SetLocalInt(GetNearestObjectByTag("c_gamemaster"), "piecefight", 0);
	SetLocalInt(attacker, "fighting", 0);
	AssignCommand(attacker, ClearAllActions());
}

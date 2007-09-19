void main() {

	location lLoc = GetLocation(GetWaypointByTag("WP_Fischer_oben"));
	object player = GetLastUsedBy();
	AssignCommand(player, JumpToLocation(lLoc));

}

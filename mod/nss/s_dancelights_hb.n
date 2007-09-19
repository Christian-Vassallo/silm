void main() {
	object
	oLight = OBJECT_SELF,
	oMaster = GetMaster();

	/*int nState = GetLocalInt(oLight, "state");
	 *
	 * switch (nState) {
	 * 	// Hold position
	 * 	case 0:
	 * 		break;
	 *
	 * 	// Follow master
	 * 	case 1:
	 * 		break;
	 *
	 * 	// Do random walk on the current location if we haven't moved much.
	 * 	case 2:
	 * 		break;
	 * }*/

	int nFollow = GetLocalInt(oLight, "follow");

	if ( nFollow )
		ActionForceFollowObject(oMaster, 1.0);

}

//Zoom in onto the player
void main() {
	float fDistance = 3.5f;
	float fPitch =  75.0f;
	float fFacing = GetFacing(GetPCSpeaker()) + 180.0;

	if ( fFacing > 359.0 ) fFacing -= 359.0;

	SetCameraFacing(fFacing, fDistance, fPitch, CAMERA_TRANSITION_TYPE_VERY_FAST);

	SetLocalInt(GetPCSpeaker(), "noclothchange", 1);
}

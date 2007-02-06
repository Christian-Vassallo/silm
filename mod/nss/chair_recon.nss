void Beams(int iStage, object oPC) {
	float fDir = GetFacing(OBJECT_SELF);
	vector vDir1 = AngleToVector(fDir + 30.0 * IntToFloat(iStage)) * 4.0;
	vector vDir2 = AngleToVector(fDir + 30.0 * IntToFloat(iStage) + 180.0) * 4.0;
	vector vStart = GetPositionFromLocation(GetLocation(OBJECT_SELF)) +
					Vector(0.0, 0.0, 1.0f);
	object oArea = GetArea(OBJECT_SELF);
	location lPos1 = Location(oArea, vStart + vDir1, 0.0);
	location lPos2 = Location(oArea, vStart + vDir2, 0.0);

	effect eBeam1 = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
	effect eBeam2 = EffectVisualEffect(VFX_DUR_MAGICAL_SIGHT);
/*
 * effect eBeam1 = EffectBeam(VFX_BEAM_LIGHTNING,oPC,BODY_NODE_HAND,FALSE);
 * effect eBeam2 = EffectBeam(VFX_BEAM_LIGHTNING,oPC,BODY_NODE_HAND,FALSE);
 */
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eBeam1, lPos1, 6.0f - IntToFloat(iStage));
	ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eBeam2, lPos2, 6.0f - IntToFloat(iStage));
}

void Commit(object oPC) {
	int iXP = GetXP(oPC);
	ApplyEffectToObject(DURATION_TYPE_INSTANT,
		EffectVisualEffect(VFX_IMP_HARM), oPC);
	SetXP(oPC, 0);
	SetXP(oPC, iXP);
}

void Stage() {
	object oPC = GetSittingCreature(OBJECT_SELF);
	int iStage = GetLocalInt(OBJECT_SELF, "stage");
	if ( !GetIsObjectValid(oPC) ) return;

	SetLocalInt(OBJECT_SELF, "stage", iStage + 1);
	Beams(iStage, oPC);
	if ( iStage > 5 )
		Commit(oPC);
	else
		DelayCommand(1.0f, Stage());
}

void main() {
	object oChair = OBJECT_SELF;
	AssignCommand(GetLastUsedBy(), ActionSit(oChair));
	DeleteLocalInt(OBJECT_SELF, "stage");
	DelayCommand(2.0f, Stage());
}

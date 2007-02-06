/*
 * This script allows jumping from one jump target to the next,
 * making appropriate DCs and appropriate results on failure.
 */
#include "_gen"

/*
 * 	Rules:
 * 		Climb Placies:
 * 		  Down->Up:  DC = Elevation
 * 		  Up->Down:  DC = 15.
 * 		  Rope Inv:  DC = DC - 10
 *
 * 		Jump Placies:
 * 		  DC = Distance + Elevation * 4
 * 		  Rope Inv:  No effect
 */

const int
BASE_DC_JUMP = 10;


void main() {
	object oJumper = GetLastUsedBy();

	string sTag = GetTag(OBJECT_SELF);

	object oTarget = GetNearestObjectByTag(sTag);

	if ( !GetIsObjectValid(oTarget) ) {
		SpeakString("No valid target nearby. Forget it.");
		return;
	}

	// 3.28: feet!
	float fDistance = GetDistanceBetween(OBJECT_SELF, oTarget) * 3.28;
	float fElevation = GetElevationBetween(OBJECT_SELF, oTarget) * 3.28;

	int nDC = 0;

	if ( "pjump" == sTag ) {

		nDC += abs(FloatToInt(fDistance)) +
			   FloatToInt(fElevation * 4); // can have neg values: jumping down is easier!

	} else if ( "pclimb" == sTag ) {

		if ( GetIsObjectValid(GetItemPossessedBy(oJumper, "rope")) )
			nDC -= 10;

		if ( fElevation < 0.0 ) {
			nDC += 10;
		} else {
			nDC += 1 + FloatToInt(fElevation);
		}

		if ( nDC > 30 )
			nDC = 30;
		if ( nDC < 1 )
			nDC = 1;


	} else {
		SpeakString("Unnown plasie, dis. Do no now wad do do! :(");
		return;
	}


	SendMessageToPC(oJumper, "Distance is: " + FloatToString(fDistance));
	SendMessageToPC(oJumper, "Elevation is: " + FloatToString(fElevation));
	SendMessageToPC(oJumper, "DC is: " + IntToString(nDC));

	// no aq exploits
	AssignCommand(oJumper, ClearAllActions());

	// He did it. Dont bother with anything else.
	if ( MakeThrow(nDC, 20, 1, GetSkillRank(SKILL_TUMBLE, oJumper)) ) {

		AssignCommand(oJumper, JumpToObject(oTarget));

		// fall on face, take damage.
	} else {

		if ( "pjump" == sTag ) {
			// he didnt make the jump.

			// if its a deadly jump, oops?
			if ( GetLocalInt(oTarget, "jump_deadly") || GetLocalInt(oTarget, "jump_deadly") ) {
				// fall down ravine or sth.


			} else {

				if ( fElevation <= 0.0 ) {
					// roll down hill/fall into water. see how it works out.
					AssignCommand(oJumper, JumpToObject(oTarget));
				}

				// and fall on your nose, and be dazed
				AssignCommand(oJumper, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 20.0));
				ApplyEffectToObject(DTT, EffectDazed(), oJumper, 10.0);

			}


			// if its a climb
		} else if ( "pclimb" == sTag ) {

			// fall down
			if ( fElevation < 0.0 ) {
				AssignCommand(oJumper, JumpToObject(oTarget));
			}

			// else:
			//  just fall _back_ down

			AssignCommand(oJumper, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 20.0));
			ApplyEffectToObject(DTT, EffectDazed(), oJumper, 10.0);

		}

		int nDamage = d6() + d3(FloatToInt(fElevation));

		//ApplyEffectToObject(DTI, EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING), oJumper);
		SendMessageToPC(oJumper, "Damage would be: " + IntToString(nDamage));
	}
}

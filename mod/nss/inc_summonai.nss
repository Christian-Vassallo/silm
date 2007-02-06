/*
 * Collection of AI routines of summoned creatures
 *
 * Provides them with a basic control and set of commands
 *
 * Operational modes:
 *
 * 1) Stay here, regardless what comes
 *     (Following off, Fighting off)
 * 2) Stay here and defend yourself
 *     (Following off, Fighting on attacked)
 * 3) Defend this spot
 *     (Following off, Fighting on sight)
 * 4) Follow me
 *     (Following on, Fighting off)
 * 5) Guard me
 *     (Following on, Fighting on attacked)
 * 6) Fight at my side
 *     (Following on, Fighting on sight)
 *
 * Transitions:
 *
 * "Follow me"
 *    In Fight      -> Stop fight, move to master
 *    Following off -> Following on
 *    Following on  -> Fighting off
 *
 * "Attack"
 *    !Fighting on sight -> Fighting on sight
 *              *        -> Attack nearest target
 *
 * "Guard me"
 *    In Fight -> Stop fight, move to master
 *           * -> Fighting on attacked
 *
 * "Stand ground"
 *           * -> Following off
 */

void DetermineCombatRound(object oIntruder = OBJECT_INVALID, int nAI_Difficulty = 10);

object GetSumMaster() {
	return GetLocalObject(OBJECT_SELF, "SUM_MASTER");
}

int IsMaster(object oPC) {
	return GetIsObjectValid(oPC) && ( GetSumMaster() == oPC );
}

int GetShouldFollow() {
	return GetLocalInt(OBJECT_SELF, "SHOULD_FOLLOW");
}

int GetShouldDefend() {
	return !GetIsObjectValid(GetSumMaster())
		   || GetLocalInt(OBJECT_SELF, "SHOULD_FIGHT") > 0;
}

int GetShouldAttack() {
	return !GetIsObjectValid(GetSumMaster())
		   || GetLocalInt(OBJECT_SELF, "SHOULD_FIGHT") > 1;
}

void SetFollowBehaviour(int iFollow) {
	SetLocalInt(OBJECT_SELF, "SHOULD_FOLLOW", iFollow);
	SendMessageToPC(GetSumMaster(), "Eure Kreatur wird euch " +
		( iFollow ? "" : "nicht " ) + "folgen.");
}

void SetFightBehaviour(int iFight) {
	SetLocalInt(OBJECT_SELF, "SHOULD_FIGHT", iFight);
	switch ( iFight ) {
		case 0:
			SendMessageToPC(GetSumMaster(), "Eure Kreatur wird nicht kaempfen.");
			break;
		case 1:
			SendMessageToPC(GetSumMaster(), "Eure Kreatur wird sich und Euch verteidigen.");
			break;
		case 2:
			SendMessageToPC(GetSumMaster(), "Eure Kreatur wird selbststaendig Feinde bekaempfen.");
			break;
	}
}

void MoveToMaster() {
	object oMaster = GetSumMaster();
	if ( GetIsObjectValid(oMaster) ) {
		float fDist = GetDistanceToObject(oMaster);
		if ( GetArea(oMaster) != GetArea(OBJECT_SELF) || fDist > 50.0 ) {
			ClearAllActions();
			ActionJumpToObject(oMaster);
		} else if ( fDist > 5.0f ) {
			ClearAllActions();
			ActionMoveToObject(oMaster, TRUE, 3.0f);
		}
	}
}

void Sum_RespondShout(object oShouter, int nMatch) {
	if ( !IsMaster(oShouter) ) return;

	switch ( nMatch ) {
		case ASSOCIATE_COMMAND_ATTACKNEAREST:
			if ( !GetShouldAttack() )
				SetFightBehaviour(2);
			else
				DetermineCombatRound();
			break;
		case ASSOCIATE_COMMAND_FOLLOWMASTER:
			if ( GetIsInCombat(OBJECT_SELF) ) {
				ClearAllActions(TRUE);
				MoveToMaster();
			} else if ( !GetShouldFollow() )
				SetFollowBehaviour(1);
			else
				SetFightBehaviour(0);
			PlayVoiceChat(VOICE_CHAT_YES);
			break;
		case ASSOCIATE_COMMAND_GUARDMASTER:
			if ( GetIsInCombat(OBJECT_SELF) )
				MoveToMaster();
			else {
				SetFollowBehaviour(1);
				SetFightBehaviour(1);
			}
			PlayVoiceChat(VOICE_CHAT_YES);
			break;
		case ASSOCIATE_COMMAND_MASTERATTACKEDOTHER:
			if ( !GetIsInCombat(OBJECT_SELF) && GetShouldAttack() )
				DetermineCombatRound();
			break;
		case ASSOCIATE_COMMAND_MASTERGOINGTOBEATTACKED:
			if ( !GetIsInCombat(OBJECT_SELF) && GetShouldDefend() )
				DetermineCombatRound();
			break;
		case ASSOCIATE_COMMAND_MASTERUNDERATTACK:
			if ( !GetIsInCombat(OBJECT_SELF) && GetShouldDefend() )
				DetermineCombatRound();
			break;
		case ASSOCIATE_COMMAND_STANDGROUND:
			SetFollowBehaviour(0);
			PlayVoiceChat(VOICE_CHAT_YES);
			break;
	}
}





// void main() { }


#include "inc_subr_fly"

void Handle_Ground(object oPC) {
	if ( !Fly_IsPCOK(oPC) ) {
		FloatingTextStringOnCreature("Ihr seid nicht in der Verfassung zu fliegen.", oPC, FALSE);
		return;
	}

	if ( !Fly_IsAreaOK(oPC) ) {
		FloatingTextStringOnCreature("Diese Gegend ist zum Abheben nicht geeignet.", oPC, FALSE);
		return;
	}

	Fly_TakeOff(oPC);
}

void Handle_TakeoffLandTo(object oPC, location lLocation) {
	if ( !Fly_IsPCOK(oPC) ) {
		FloatingTextStringOnCreature("Ihr seid nicht in der Verfassung zu fliegen.", oPC, FALSE);
		return;
	}

	if ( !Fly_IsAreaOK(oPC) ) {
		FloatingTextStringOnCreature("Diese Gegend ist zum Abheben nicht geeignet.", oPC, FALSE);
		return;
	}

	float duration = 2.5f;
	float distance = GetDistanceBetweenLocations(GetLocation(oPC), lLocation);

	int iTime = ( FloatToInt(distance) / 20 );
	if ( iTime < 0 )
		iTime = 0;
	duration += iTime;

	//SendMessageToPC(oPC, "Du hast " + FloatToString(distance) + " Meter zurueckgelegt / Mod: " + IntToString(iTime));

	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDisappearAppear(lLocation), oPC, duration);
}

void Handle_Airborne(object oPC) {
	if ( !Fly_IsAreaOK(oPC) ) {
		FloatingTextStringOnCreature("Diese Gegend ist zum Landen ungeeignet.", oPC, FALSE);
		return;
	}
	Fly_Land(oPC);
}

void Handle_FlyTo(object oPC, location lTarget) {
	AssignCommand(oPC, ActionJumpToLocation(lTarget));
}

void _Handle_AerialAttack(object oPC, object oTarget) {
	int iDice = d20();
	int iRes;

	if ( iDice == 20 ) iRes = 2;
	else if ( iDice == 1 ) iRes = 0;
	else
		iRes = ( iDice + GetBaseAttackBonus(oPC) >= GetAC(oTarget) );

	SendMessageToPC(oPC, "Rammstoss: " +
		IntToString(iDice) + " + " + IntToString(GetBaseAttackBonus(oPC)) + " vs. " +
		IntToString(GetAC(oTarget)));

	if ( iRes > 0 ) {
		int iDamage = d10(3);
		if ( iRes > 1 ) iDamage *= 2;

		SendMessageToPC(oPC, "Rammstoss: Treffer, " + IntToString(iDamage) + " Schadenspunkte.");
		ApplyEffectToObject(DURATION_TYPE_INSTANT,
			EffectDamage(iDamage, DAMAGE_TYPE_BLUDGEONING), oTarget);
	} else
		SendMessageToPC(oPC, "Rammstoss: Verfehlt!");
}

void Handle_AerialAttack(object oPC, object oTarget) {
	if ( GetDistanceBetween(oPC, oTarget) < 3.0f ) {
		SendMessageToPC(oPC, "Fuer einen Rammstoss muss man mindestens drei Meter entfernt sein.");
		return;
	}
	AssignCommand(oPC, ActionForceMoveToObject(oTarget, TRUE));
	AssignCommand(oPC, ActionDoCommand(_Handle_AerialAttack(oPC, oTarget)));
}

void main() {
	object oTarget = GetLocalObject(OBJECT_SELF, "SR_IAct_Obj");
	location lTarget = GetLocalLocation(OBJECT_SELF, "SR_IAct_Loc");

	if ( Fly_IsAirborne(OBJECT_SELF) ) {
		if ( !GetIsObjectValid(oTarget) )
			Handle_FlyTo(OBJECT_SELF, lTarget);
		else if ( oTarget != OBJECT_SELF )
			Handle_AerialAttack(OBJECT_SELF, oTarget);
		else
			Handle_Airborne(OBJECT_SELF);
	} else {
		if ( !GetIsObjectValid(oTarget) )
			Handle_TakeoffLandTo(OBJECT_SELF, lTarget);
		else
			Handle_Ground(OBJECT_SELF);
	}
}

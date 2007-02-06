#include "_gen"
#include "x2_inc_spellhook"


void CycleShieldOther(object oCleric, object oTarget, int nLastHP, int nLastMaxHP, float fRemaining,
					  float fInterval);


void main() {
	object oCaster = OBJECT_SELF;
	object oTarget = GetSpellTargetObject();
	int nMetaFlag = GetMetaMagicFeat();
	int nLevel = GetCasterLevel(oTarget);

	if ( !GetIsPC(oTarget) ) {
		Floaty("Das Ziel muss ein anderer Spieler sein.", oCaster);
		return;
	}


	if ( GetLocalInt(oTarget, "shield_other") ) {
		Floaty("Das Ziel wird bereits durch Andere Schuetzen geschuetzt.", oCaster);
		return;
	}
	int nDuration = 1 * nLevel;

	if ( METAMAGIC_EXTEND == nMetaFlag )
		nDuration *= 2;

	// The subject gains a +1 deflection bonus to AC and a +1 resistance bonus on saves.
	effect eAC = EffectACIncrease(1, AC_DEFLECTION_BONUS);
	effect eLink = EffectLinkEffects(eAC, EffectSavingThrowIncrease(SAVING_THROW_ALL, 1));

	ApplyEffectToObject(DTT, eLink, oTarget, HoursToSeconds(nDuration));

	float fInterval = 1.5f;

	DelayCommand(HoursToSeconds(nDuration), CycleShieldOther(oCaster, oTarget,
			GetCurrentHitPoints(oTarget), GetMaxHitPoints(oTarget), HoursToSeconds(nDuration), fInterval));

	SetupReminder(OBJECT_SELF, GetSpellName(GetSpellId()), HoursToSeconds(nDuration), eLink);
}



void CycleShieldOther(object oCleric, object oTarget, int nLastHP, int nLastMaxHP, float fRemaining,
					  float fInterval) {
	int nCurrentHP = GetCurrentHitPoints(oTarget);
	int nMaxHP = GetMaxHitPoints(oTarget);

	int nClericCurrentHP = GetCurrentHitPoints(oCleric);

	// Oy. Its dead, Jim.
	// End the spell, show's over.
	if ( nCurrentHP < -9 ) {
		SendMessageToPC(oCleric, "Andere Schuetzen endet (Ziel tot).");
		SetLocalInt(oTarget, "shield_other", 0);
		return;
	}

	// Oyyy! Its us that'll be dead.
	// End the spell, show's over.
	if ( nClericCurrentHP < -9 ) {
		SendMessageToPC(oCleric, "Andere Schuetzen endet (Schuetzender tot).");
		SetLocalInt(oTarget, "shield_other", 0);
		return;
	}

	// some non-hitpoint-damage-drain
	if ( nLastMaxHP > nMaxHP && nLastHP > nMaxHP )
		nLastHP -= nLastMaxHP - nMaxHP;

	if ( nCurrentHP < nLastHP ) {
		int nSplitDamage = ( nLastHP - nCurrentHP ) / 2;
		if ( nSplitDamage > 0 ) {
			ApplyEffectToObject(DTI, EffectHeal(nSplitDamage), oTarget);
			ApplyEffectToObject(DTI, EffectDamage(nSplitDamage), oCleric);
			SendMessageToPC(oCleric, "Du hast " +
				IntToString(nSplitDamage) + " Schaden durch 'Andere Schuetzen' erhalten.");
			SendMessageToPC(oTarget, "Du hast " +
				IntToString(nSplitDamage) + " Schaden durch 'Andere Schuetzen' vermieden.");

			nCurrentHP += nSplitDamage;
		}
	}

	// End the spell
	if ( fRemaining < fInterval ) {
		SetLocalInt(oTarget, "shield_other", 0);
		SendMessageToPC(oCleric, "Andere Schuetzen endet.");
		return;
	}

	DelayCommand(fInterval, CycleShieldOther(oCleric, oTarget, nCurrentHP, nMaxHP, fRemaining -
			fInterval, fInterval));
}

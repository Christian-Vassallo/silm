//::///////////////////////////////////////////////
//:: Heiltasche
//:: inc_healerkit
//:://////////////////////////////////////////////
/*
 *
 */
//:://////////////////////////////////////////////
//:: Created By: Torsten Sens
//:: Created On: 27.02.2005
//:://////////////////////////////////////////////

#include "inc_setting"
// #include "inc_nwnx"

// regenerates nHitPoints of oPC in several Minutes
void UseBandage(object oPC, int nHitPoints);

// oPC makes zrw with HealBoni and removes eDisease from oPC
void UseMedicine(object oPC, object oTarget, object oItem, effect eDisease);

// Cures the Disease of oPC with HealSkillBoni
void CureDisease(object oPC, effect eDisease, int nHealSkill);

// Use HealerKit
// -object oHealer: User of healerKit
// -object oTarget: Pacient of Healer
// -object oItem: HealerKit Object
void UseHealerKit(object oHealer, object oTarget, object oItem);

// Add Bandage to Object Target
// If oTarget is a HealerKit it will fill in Content
// if oTarget is a Person with negative HitPoints it will be stabilized
// else nothing will happen
void AddBandage(object oPC, object oTarget, object oItem);

// Adds Medicine to Obect Target
// If oTarget is an sick Creature it will become chance to Cure
// if oTarget is a HealerKit it will fill to Content
void AddMedicine(object oPC, object oTarget, object oItem);

//returns Medicine Value of oHealerKit
int GetMedicineValue(object oHealerKit);

//returns Bandage Value of oHealerKit
int GetBandageValue(object oHealerKit);


// Make oPC try to stabilise oTarget (prevent from dying.
// This uses up oItem
void Stabilise(object oPC, object oTarget, object oItem);


// Updates oHealerKit.
void SetHealerKitValues(object oHealerKit, int nBandage, int nMedicine);

void UseHealerKit(object oHealer, object oTarget, object oItem) {
	if ( GetIsInCombat(oHealer) ) {

		FloatingTextStringOnCreature("Sie koennen keine Heilertasche im Kampf benutzen!", oHealer, FALSE);

	} else {

		if ( GetIsObjectValid(oTarget) ) {
			if ( GetDistanceBetween(oHealer, oTarget) < 2.0 ) {
				if ( GetBandageValue(oItem) >= 1 ) {

					// SendMessageToPC(oHealer, "Bandagen: "+ IntToString(GetBandageValue(oItem)));
					// negative HitPoints is a dying PC


					// full HitPoints no need of Bandages
					if ( GetCurrentHitPoints(oTarget) >= GetMaxHitPoints(oTarget) ) {
						FloatingTextStringOnCreature("Das Ziel ist nicht verletzt.", oHealer, FALSE);
						return;
					}

					// if it's not bandaged, do it now
					if ( GetCurrentHitPoints(oTarget) < 0 && GetIsPC(oTarget) )
						AddBandage(oHealer, oTarget, oItem);

					if ( GetLocalInt(oTarget, "bandage") != 1 ) {
						int nHealth = GetSkillRank(SKILL_HEAL, oHealer) + d20();
						SetLocalInt(oTarget, "bandage", 1);
						//AssignCommand(oHealer, ActionSpeakString("*Verbindet die Wunden von "+ GetName(oTarget) +"*", TALKVOLUME_TALK));
						AssignCommand(oHealer, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 3.0));
						SetHealerKitValues(oItem, GetBandageValue(oItem) - 1, GetMedicineValue(oItem)); //Reduce Bandage of HealerKit
						UseBandage(oTarget, nHealth);
					} else
						FloatingTextStringOnCreature("Das Ziel traegt bereits Verbaende.", oHealer, FALSE);
				} else {
					FloatingTextStringOnCreature("In der Heiltasche sind keine Verbandsmaterialien mehr.",
						oHealer, FALSE);
				}
				// DiseaseCheck
				effect eEffect = GetFirstEffect(oTarget);
				while ( GetIsEffectValid(eEffect) ) {
					//already get medicine?
					if ( GetLocalInt(oTarget, "medicine") != 1 ) {
						// if it's enought Medicine in the HealerKit, use it
						if ( GetMedicineValue(oItem) >= 1 ) {
							//SendMessageToPC(oHealer, "Medizin: "+ IntToString(GetMedicineValue(oItem)));
							// is Diseased or Poisened?
							if ( GetEffectType(eEffect) == EFFECT_TYPE_DISEASE
								|| GetEffectType(eEffect) == EFFECT_TYPE_POISON ) {
								SetHealerKitValues(oItem, GetBandageValue(oItem), GetMedicineValue(oItem) - 1); //Reduce medicine of HealerKit
								UseMedicine(oHealer, oTarget, oItem, eEffect);
							}
						} else {
							FloatingTextStringOnCreature("In der Heiltasche sind keine Medikamente mehr.",
								oHealer, FALSE);
						}
					}
					eEffect = GetNextEffect(oTarget);
				}
			} else {
				FloatingTextStringOnCreature("Sie sind zu weit entfernt!", oHealer, FALSE);
			}
		} else {
			FloatingTextStringOnCreature("Kein gueltiges Ziel!", oHealer, FALSE);
		}
	}
}

void UseBandage(object oPC, int nHitPoints) {
	int nHeal = d3() + GetAbilityModifier(ABILITY_CONSTITUTION, oPC);

	if ( nHeal > nHitPoints ) {
		nHeal = nHitPoints;
	}
	if ( GetCurrentHitPoints(oPC) + nHeal > GetMaxHitPoints(oPC) ) {
		nHeal = GetMaxHitPoints(oPC) - GetCurrentHitPoints(oPC);
	}
	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHeal), oPC);
	nHitPoints = nHitPoints - nHeal;
	if ( nHitPoints > 0 && GetCurrentHitPoints(oPC) < GetMaxHitPoints(oPC) ) {
		int nDelay = ( d6() * 10 ) + 120;   //2-3 minuten
		//FloatingTextStringOnCreature("DebugInfo: Noch zu heilende HP: "+ IntToString(nHitPoints),oPC,FALSE);
		DelayCommand(IntToFloat(nDelay), UseBandage(oPC, nHitPoints));
	} else {
		DeleteLocalInt(oPC, "bandage");
	}
}

void UseMedicine(object oPC, object oTarget, object oItem, effect eDisease) {
	SetLocalInt(oTarget, "medicine", 1);
	//AssignCommand(oPC, ActionSpeakString("*Verabreicht "+ GetName(oTarget) +" eine kleine runde Pille*", TALKVOLUME_TALK));
	AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 3.0));
	int nHealSkill;
	if ( GetResRef(oTarget) == "healerkit" ) {
		nHealSkill = GetSkillRank(SKILL_HEAL, oPC);
	} else if ( GetResRef(oItem) == "medicine" ) {
		nHealSkill = d3();
	}
	if ( GetEffectType(eDisease) == EFFECT_TYPE_DISEASE ) {
		DelayCommand(180.0, CureDisease(oTarget, eDisease, nHealSkill));
		DelayCommand(181.0, DeleteLocalInt(oTarget, "medicine"));
	} else if ( GetEffectType(eDisease) == EFFECT_TYPE_POISON ) {
		effect eBoni = EffectSavingThrowIncrease(SAVING_THROW_FORT, nHealSkill, SAVING_THROW_TYPE_POISON);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBoni, oTarget);
		if ( FortitudeSave(oTarget, 20, SAVING_THROW_TYPE_POISON) == 1 ) {
			RemoveEffect(oTarget, eBoni);
			RemoveEffect(oTarget, eDisease);
		} else {
			RemoveEffect(oTarget, eBoni);
		}
		DelayCommand(91.0, DeleteLocalInt(oTarget, "medicine"));
	}
}

void AddBandage(object oPC, object oTarget, object oItem) {
	if ( GetLocalInt(GetModule(), "debug") )
		SendMessageToAllDMs("inc_healerkit#AddBandage: " +
			GetName(oPC) + " uses on " + GetName(oTarget) + ", item: " + GetName(oItem) + " " + GetTag(oItem));

	if ( GetIsObjectValid(oTarget) ) {

		if ( GetDistanceBetween(oPC, oTarget) < 2.0 ) {

			if ( GetObjectType(oTarget) == OBJECT_TYPE_CREATURE ) {

				int nHitPoints = GetCurrentHitPoints(oTarget);

				if ( nHitPoints < 0 ) {
					//negative HitPoints will be stabilized
					int nHealSkill = GetSkillRank(SKILL_HEAL, oPC);
					AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 3.0));
					if ( d20() + nHealSkill >= 15 ) {
						int nHealPoints = 1 - nHitPoints;
						if ( nHealSkill < nHealPoints ) {
							nHealPoints = nHealSkill;
						}
						ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHealPoints), oTarget);
						AssignCommand(oPC, ActionSpeakString("*Stillt die Blutungen von " +
								GetName(oTarget) + "*", TALKVOLUME_TALK));
					} else {
						AssignCommand(oPC, ActionSpeakString("*Versucht vergeblich die Blutung von " +
								GetName(oTarget) + " zu stoppen*", TALKVOLUME_TALK));
					}
					if ( GetResRef(oItem) == "healerkit" ) {
						SetHealerKitValues(oItem, GetBandageValue(oItem) - 1, GetMedicineValue(oItem)); //Reduce Bandage of HealerKit
					} else {
						DestroyObject(oItem);
					}
				} else {
					// hp >= 0
					FloatingTextStringOnCreature(
						"Dieser Charakter ist bereits stabilisiert.  Um einen permanenten Verband anzulegen, benutzt eine Heilertasche.",
						oPC, FALSE);
				}
			}

			if ( GetResRef(oTarget) == "healerkit" ) {
				int nBandage = GetBandageValue(oTarget);
				if ( nBandage < gvGetInt("healerkit_max_medicines") ) {
					FloatingTextStringOnCreature("Die Bandage wurde der Heiltasche hinzugefuegt.", oPC, FALSE);
					SetHealerKitValues(oTarget, GetBandageValue(oTarget) + 1, GetMedicineValue(oTarget));
					DestroyObject(oItem);
				} else {
					FloatingTextStringOnCreature("Die Heiltasche ist voll.", oPC, FALSE);
				}
			}
		} else {
			FloatingTextStringOnCreature("Sie sind zu weit entfernt!", oPC, FALSE);
		}
	} else {
		FloatingTextStringOnCreature("Kein gueltiges Ziel!", oPC, FALSE);
	}
}


void AddMedicine(object oPC, object oTarget, object oItem) {
	if ( GetLocalInt(GetModule(), "debug") )
		SendMessageToAllDMs("inc_healerkit#AddMedicine: " +
			GetName(oPC) + " uses on " + GetName(oTarget) + ", item: " + GetName(oItem) + " " + GetTag(oItem));

	if ( GetIsObjectValid(oTarget) ) {
		if ( GetDistanceBetween(oPC, oTarget) < 2.0 ) {
			if ( GetResRef(oTarget) == "healerkit" ) {
				int nBandage = GetMedicineValue(oTarget);
				if ( nBandage < gvGetInt("healerkit_max_medicines") ) {
					SetHealerKitValues(oTarget, GetBandageValue(oTarget), GetMedicineValue(oTarget) + 1);
					DestroyObject(oItem);
				} else {
					FloatingTextStringOnCreature("Die Heiltasche ist voll", oPC, FALSE);
				}
			}
			if ( GetObjectType(oTarget) == OBJECT_TYPE_CREATURE ) {
				effect eEffect = GetFirstEffect(oTarget);
				while ( GetIsEffectValid(eEffect) ) {
					// is Diseased or Poisened?
					if ( GetEffectType(eEffect) == EFFECT_TYPE_DISEASE
						|| GetEffectType(eEffect) == EFFECT_TYPE_POISON ) {
						//already get medicine?
						if ( GetLocalInt(oTarget, "medicine") != 1 ) {
							UseMedicine(oPC, oTarget, oItem, eEffect);
							DestroyObject(oItem);
						}
					}
					eEffect = GetNextEffect(oTarget);
				}
			}
		} else {
			FloatingTextStringOnCreature("Sie sind zu weit entfernt!", oPC, FALSE);
		}
	} else {
		FloatingTextStringOnCreature("Kein gueltiges Ziel!", oPC, FALSE);
	}
}

void CureDisease(object oPC, effect eDisease, int nHealSkill) {
	effect eBoni = EffectSavingThrowIncrease(SAVING_THROW_FORT, nHealSkill, SAVING_THROW_TYPE_DISEASE);
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBoni, oPC);
	if ( FortitudeSave(oPC, 20, SAVING_THROW_TYPE_DISEASE) == 1 ) {
		RemoveEffect(oPC, eBoni);
		RemoveEffect(oPC, eDisease);
	} else {
		RemoveEffect(oPC, eBoni);
	}
}

int GetBandageValue(object oHealerKit) {
	string name = GetName(oHealerKit);
	int nIndex = FindSubString(name, ":");
	if (-1 == nIndex)
		return 0;

	int nOldVal = StringToInt(GetSubString(name, nIndex + 2, 2));
	if (nOldVal > gvGetInt("healerkit_max_bandages"))
		return gvGetInt("healerkit_max_bandages");

	return nOldVal;
}


int GetMedicineValue(object oHealerKit) {
	int length = GetStringLength(GetName(oHealerKit));
	int nOldVal = StringToInt(GetSubString(GetName(oHealerKit), length - 3, length - 2 ));
	if (nOldVal > gvGetInt("healerkit_max_medicines"))
		return gvGetInt("healerkit_max_medicines");

	return nOldVal;
}

void SetHealerKitValues(object oHealerKit, int nBandage, int nMedicine) {
	// SetLocalInt(oHealerKit, "bandages", nBandage);
	// SetLocalInt(oHealerKit, "medicines", nMedicine);

	string sBandage = IntToString(nBandage);
	string sMedicine = IntToString(nMedicine);

	SetName(oHealerKit, "Heiltasche (Bandagen: " + sBandage + " / Medikamente: " + sMedicine + ")");
}

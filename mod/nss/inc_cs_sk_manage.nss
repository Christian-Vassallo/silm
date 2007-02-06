#include "inc_cs_sk_data"
#include "inc_lists"
#include "inc_persist"
#include "inc_debug"

void MakeSkGroupList(object oPC) {
	int iNSkg = GetLocalInt(GetModule(), "CS_SKG_Count");
	int i;
	struct SkGroup curr;

	ClearList(oPC, "CS_CRList");

	for ( i = 0; i < iNSkg; i++ ) {
		curr = GetSkGroupData(i);
		if ( curr.sDesc != "" ) {
			AddListItem(oPC, "CS_CRList", curr.sDesc);
			SetListInt(oPC, "CS_CRList", i);
		}
	}
}

void MakeSkList(object oPC, int iGrIndex) {
	int iNSk = GetLocalInt(GetModule(), "CS_SKS_Count");
	int i, iSum = 0;
	struct Skill curr;

	ClearList(oPC, "CS_CRList");
	for ( i = 0; i < iNSk; i++ ) {
		curr = GetSkillData(i);
		if ( curr.iGroup == iGrIndex ) {
			AddListItem(oPC, "CS_CRList", curr.sDesc);
			SetListInt(oPC, "CS_CRList", i);
			SetListString(oPC, "CS_CRList", curr.sLabel);

			iSum += GetLegacyPersistentInt(oPC, "CS_Skill_" + curr.sLabel);
		}
	}
	SetLocalInt(oPC, "CS_Sk_Sum", iSum);
}

string SkillDescription(object oPC, int iSkill) {
	struct Skill curr = GetSkillData(iSkill);
	struct SkGroup curr2 = GetSkGroupData(curr.iGroup);

	return "Skill " + curr.sDesc + ": Sie haben " +
		   IntToString(GetLegacyPersistentInt(oPC, "CS_Skill_" + curr.sLabel)) +
		   " Punkte von " + IntToString(curr2.iSMax) + " maximal moeglichen.";
}

void MakeSkListDialog(object oPC) {
	int iDiaCurr = GetLocalInt(oPC, "CS_SK_DiaCurr");
	int iGroup;
	struct SkGroup curr;
	string s;

	switch ( iDiaCurr ) {
		case 0:
			MakeSkGroupList(oPC);
			ResetConvList(oPC, oPC, "CS_CRList", 50000, "cs_sk_browse",
				"Fertigkeiten auflisten: Welche Gruppe?");
			break;
		case 1:
			MakeSkList(oPC, ( iGroup = GetLocalInt(oPC, "CS_ChGroup") ));
			curr = GetSkGroupData(iGroup);

			s = "In dieser Gruppe haben Sie im Moment " +
				IntToString(GetLocalInt(oPC, "CS_Sk_Sum")) + " von maximal " +
				IntToString(curr.iGMax) + " Punkten.";

			ResetConvList(oPC, oPC, "CS_CRList", 50000, "cs_sk_browse",
				s,
				"", "",
				"cs_sk_mrevert");
			break;
		case 2:
			ClearList(oPC, "CS_CRList");
			ResetConvList(oPC, oPC, "CS_CRList", 50000, "",
				SkillDescription(oPC, GetLocalInt(oPC, "CS_ChSkill")),
				"", "",
				"cs_sk_mrevert");
			break;
	}
}

void SkListDialog_Revert(object oPC) {
	int iDiaCurr = GetLocalInt(oPC, "CS_SK_DiaCurr");

	if ( iDiaCurr > 0 )
		SetLocalInt(oPC, "CS_SK_DiaCurr", iDiaCurr - 1);
	MakeSkListDialog(oPC);
}

void SkListDialog_Choose(object oPC) {
	int iDiaCurr = GetLocalInt(oPC, "CS_SK_DiaCurr");
	int iSelect = GetLocalInt(oPC, "ConvList_Select");

	SetLocalInt(oPC, "CS_SK_DiaCurr", iDiaCurr + 1);

	switch ( iDiaCurr ) {
		case 0:
			SetLocalInt(oPC, "CS_ChGroup",
				GetListInt(oPC, "CS_CRList", iSelect));
			MakeSkListDialog(oPC);
			break;
		case 1:
			SetLocalInt(oPC, "CS_ChSkill",
				GetListInt(oPC, "CS_CRList", iSelect));
			MakeSkListDialog(oPC);
			break;
		default:
			FloatingTextStringOnCreature("Not implemented.", oPC);
			break;
	}
}

int GetGroupSum(object oPC, string sLabel) {
	struct Skill cSkill = GetSkillData_Label(sLabel);
	struct SkGroup cSkGroup = GetSkGroupData(cSkill.iGroup);
	struct Skill curr;

	int i, iNSk = GetLocalInt(GetModule(), "CS_SKS_Count");
	int iSum = 0;

	for ( i = 0; i < iNSk; i++ ) {
		curr = GetSkillData(i);
		if ( curr.iGroup == cSkill.iGroup )
			iSum += GetLegacyPersistentInt(oPC, "CS_Skill_" + curr.sLabel);
	}
	return iSum;
}

int GetSkillValue(object oPC, string sLabel) {
	return GetLegacyPersistentInt(oPC, "CS_Skill_" + sLabel);
}

void SetSkillValue(object oPC, string sLabel, int iValue) {
	//SetPersistentInt(oPC,"CS_Skill_"+sLabel,iValue);
}

int CheckSkill(object oPC, string sLabel, int iDifficulty) {
	int iRes = GetSkillValue(oPC, sLabel) + d20();
	return iRes >= iDifficulty;
}

int CheckImproveSkill(object oPC, string sLabel, int iDifficulty, int RaiseProb = 10) {
	if ( !CheckSkill(oPC, sLabel, iDifficulty) ) return 0;

	if ( !Random(RaiseProb) ) {
		struct Skill curr = GetSkillData_Label(sLabel);
		struct SkGroup cgrp = GetSkGroupData(curr.iGroup);

		int iSkV = GetSkillValue(oPC, sLabel);
		if ( iSkV >= cgrp.iSMax || GetGroupSum(oPC, sLabel) >= cgrp.iGMax )
			return 1;

		SetSkillValue(oPC, sLabel, iSkV + 1);
	}
	return 1;
}

int GetItemDifficulty(string sBOT, int iMatIndex) {
	struct ItemType curr;

	if ( sBOT != "" ) {
		curr = GetItemType_BOT(sBOT);
		return ( 1 << iMatIndex ) + curr.iBaseDiff;
	}

	return 1 << iMatIndex;
}

string GetDifficultyString(object oPC, string sLabel, int iDifficulty) {
	int iSkV = GetSkillValue(oPC, GetStringLeft(sLabel, 1));

	//Broken with style guide for readability
	if ( iSkV    >= iDifficulty ) return "trivial";

	if ( iSkV + 5  >= iDifficulty ) return "einfach";

	if ( iSkV + 10 >= iDifficulty ) return "maessig";

	if ( iSkV + 15 >= iDifficulty ) return "schwer";

	if ( iSkV + 20 >= iDifficulty ) return "sehr schwer";

	return "unmoeglich";
}


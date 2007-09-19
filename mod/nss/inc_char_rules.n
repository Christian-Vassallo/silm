#include "_gen"

int CharacterNeedsRegistering(object oPC);





int CharacterNeedsRegistering(object oPC) {
	int iR = GetRacialType(oPC);

	string sS = GetStringLowerCase(GetSubRace(oPC));
	if ( RACIAL_TYPE_FEY == iR
		//RACIAL_TYPE_HALFORC == iR ||
		//RACIAL_TYPE_HUMANOID_ORC == iR
	)
		return 1;


	if (
		TestStringAgainstPattern("**vampir**", sS)
		|| TestStringAgainstPattern("**pixie**", sS)
		|| TestStringAgainstPattern("**gnoll**", sS)
		|| //        TestStringAgainstPattern("**ork**", sS) ||
//        TestStringAgainstPattern("**orc**", sS) ||
		TestStringAgainstPattern("**pixie**", sS)
		|| TestStringAgainstPattern("fee**", sS)
		|| TestStringAgainstPattern("**aasimar**", sS)
		|| TestStringAgainstPattern("**tiefling**", sS)
		|| TestStringAgainstPattern("**kind**", sS)
		|| TestStringAgainstPattern("**drow**", sS)
		|| TestStringAgainstPattern("duergar**", sS)
		|| TestStringAgainstPattern("tiefenzwerg**", sS)
		|| TestStringAgainstPattern("schwarzwerg**", sS)
		|| TestStringAgainstPattern("**pinguin**", sS)
		|| TestStringAgainstPattern("**lythari**", sS)
		|| TestStringAgainstPattern("**avariel**", sS)
		|| TestStringAgainstPattern("wer**", sS)
	)
		return 1;

	if ( GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL )
		return 1;

	if ( GetTotalLevel(oPC) > 4 )
		return 1;

	return 0;
}

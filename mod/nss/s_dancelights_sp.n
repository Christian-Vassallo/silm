#include "_gen"

void main() {
	int nSpell = GetLastSpell();
	int nSpellDC = GetSpellSaveDC();

	int nCastLevel = GetLocalInt(OBJECT_SELF, "dancelights_level");

	/*if (d20() + nCastLevel >= nSpellDC) {
	 * 	// saved!
	 * 	return;
	 * }*/

	if (
		SPELL_DISPEL_MAGIC == nSpell
		|| SPELL_GREATER_DISPELLING == nSpell
		|| SPELL_LESSER_DISPEL == nSpell
		|| SPELL_MORDENKAINENS_DISJUNCTION == nSpell
	) {
		RemoveAllEffects(OBJECT_SELF);
		DestroyObject(OBJECT_SELF, 1.0f);
	}
}

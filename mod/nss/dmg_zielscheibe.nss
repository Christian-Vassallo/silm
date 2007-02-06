void main() {

	object oAttacker = GetLastAttacker();
	object oWeapon = GetLastWeaponUsed(oAttacker);
	int iWeaponType = GetBaseItemType(oWeapon);
	float fDistance = GetDistanceToObject(oAttacker);

	if ( GetWeaponRanged(oWeapon) ) {
		if ( fDistance < 8.0 ) return;

		int iADex = GetAbilityModifier(ABILITY_DEXTERITY, oAttacker);
		int iHit = d20() + iADex - FloatToInt(fDistance) / 8 + 1;
		SendMessageToPC(oAttacker, IntToString(iHit));
		iHit /= 4;
		string sWeapon;
		if ( iWeaponType == BASE_ITEM_DART ) sWeapon = "Der Wurfpfeil steckt in der";
		else if ( iWeaponType == BASE_ITEM_LONGBOW
				 || iWeaponType == BASE_ITEM_SHORTBOW ) sWeapon = "Der Pfeil steckt in der";

		else if ( iWeaponType == BASE_ITEM_LIGHTCROSSBOW
				 || iWeaponType == BASE_ITEM_HEAVYCROSSBOW ) sWeapon = "Der Bolzen steckt in der";
		else if ( iWeaponType == BASE_ITEM_SHURIKEN ) sWeapon = "Der Wurfstern steckt in der";
		else if ( iWeaponType == BASE_ITEM_THROWINGAXE ) sWeapon = "Das Wurfbeil steckt in der";
		else if ( iWeaponType == BASE_ITEM_SLING ) sWeapon = "Der Stein prallt gegen die";
		else return;

		string sMessage;
		if ( iHit < 1 ) sMessage = " Befestigung";
		else if ( iHit < 5 ) sMessage = " " + IntToString(iHit);
		else sMessage = " Mitte!";

		SpeakString(sWeapon + sMessage);
	}
}

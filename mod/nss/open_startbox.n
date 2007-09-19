void main() {

	object oShop = GetNearestObjectByTag("st_startequip");
	object oPC = GetLastOpenedBy();
	if ( GetXP(oPC) > 6000 ) {
		SendMessageToPC(oPC,
			"Sie haben keinen Zugang mehr zur Startausruestung, da sie bereits Erfahrung in unserer Welt gesammelt haben.");
	} else {
		OpenStore(oShop, oPC);
	}
}

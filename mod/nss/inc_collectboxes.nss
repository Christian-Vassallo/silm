// A generic script to allow for money collection.

#include "inc_mysql"
#include "_gen"



void OnCollectboxDisturb(object oGivenByPC, object oItem) {

	string sName = GetLocalString(OBJECT_SELF, "collectbox_name");
	if ( sName == "" ) {
		SendMessageToAllDMs("Collectbox has no name set.");
		return;
	}

	if ( GetStringLeft(GetResRef(oItem), 5) != "coin_" ) {
		ToPC("Dieses Objekt passt nicht durch den Schlitz.", oGivenByPC);
		ActionGiveItem(oItem, oGivenByPC);
		return;
	}                                             //coin_0100

	int nMulti = StringToInt(GetStringRight(GetResRef(oItem), 4));
	int nAmount = GetItemStackSize(oItem) * nMulti;

	if ( nAmount > 0 )
		SQLQuery("update collectboxes set `value`=`value`+" +
			IntToString(nAmount) + " where `name`=" + SQLEscape(sName) + " limit 1;");

	DestroyObject(oItem);
	FloatingTextStringOnCreature(
		"Ein leises Klimpern erklingt, als die Muenzen am Boden des Sammelgefaesses auftreffen.", oGivenByPC,
		1);

	return;
}

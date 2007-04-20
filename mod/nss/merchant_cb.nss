#include "inc_audit"
#include "inc_merchant"
#include "inc_currency"


void main() {
	object oPC = GetLocalObject(OBJECT_SELF, "ConvList_PC");
	object oMerc = OBJECT_SELF;

	int nMenuLevel0 = GetMenuLevel(oPC, TTT, 0);
	int nMenuLevel1 = GetMenuLevel(oPC, TTT, 1);
	int nSelected   = GetListSelection(oPC);


	string sMerc = SQLEscape(GetStringLowerCase(GetTag(oMerc)));


	SQLQuery("select text_pcnomoney,text_mercnomoney,money,money_limited from merchants where tag = " +
		sMerc + " limit 1;");

	if ( !SQLFetch() ) {
		SendMessageToPC(oPC,
			"Bug. :/ Kein Haendler mit diesem tag gefunden, aber NPC hat Script dran. Hm, hm. Datenbank offski?");
		return;
	}


	string
	sTextPCNoMoney = SQLGetData(1),
	sTextMercNoMoney = SQLGetData(2);

	int nMercMoney = StringToInt(SQLGetData(3)),
		nPCMoney = Money2Value(CountCreatureMoney(oPC)),
		bLimitedMoney = StringToInt(SQLGetData(4));


	if ( 0 == nMenuLevel0 ) {

		// Buy from merchant.
		if ( 0 == nSelected ) {
			SetMenuLevel(oPC, TTT, 0, 1);

			// Sell to merchant.
		} else if ( 1 == nSelected ) {
			SetMenuLevel(oPC, TTT, 0, 2);
		}


		/*} else if (1 == nMenuLevel0) {
		 * 	// sell one
		 * 	if (1 == nSelected) {
		 * 		SetMenuLevel(oPC, TTT, 1, 1);
		 *
		 * 	// sell 5
		 * 	} else if (2 == nSelected) {
		 * 		SetMenuLevel(oPC, TTT, 1, 2);
		 *
		 * 	// sell all
		 * 	} else if (3 == nSelected) {
		 * 		SetMenuLevel(oPC, TTT, 1, 3);
		 *
		 * 	}
		 */

		// Buy from merchant.
	} else if ( 1 == nMenuLevel0 ) {
		// Player buys nSelected from Merc
		string sBuyWhat = GetListString(oPC, TTT, nSelected);
		int nPCPaysHowMuch = GetListInt(oPC, TTT, nSelected);
		float fMax = GetListFloat(oPC, TTT, nSelected);


		if ( nPCMoney < nPCPaysHowMuch ) {
			SpeakString(sTextPCNoMoney);
		} else {
			// Create Item
			object oThing = CreateItemOnObject(sBuyWhat, oPC, 1, sBuyWhat);
			if ( !GetIsObjectValid(oThing) ) {
				SendMessageToPC(oPC, "Bug: Cant give item! Create() failed.");

			} else {
				// Take Money
				TakeValueFromCreature(nPCPaysHowMuch, oPC, TRUE);

				// Update DB
				if ( 0.0 != fMax )
					SQLQuery(
						"update merchant_inventory set cur = cur - 1 where merchant = (select id from merchants where tag = "
						+ sMerc + " limit 1) and resref = " + SQLEscape(sBuyWhat) + " limit 1;");

				SQLQuery("update merchants set money = money + " +
					IntToString(nPCPaysHowMuch) + " where tag = " + sMerc + " limit 1;");

				audit("buy", oPC, audit_fields("merchant", GetTag(oMerc), "resref", sBuyWhat, "price",
						IntToString(nPCPaysHowMuch)), "merchant");
			}
		}

		// Sell to  merchant.
	} else if ( 2 == nMenuLevel0 ) {
		// Player sells nSelected to Merc
		string sSellsWhat = GetListString(oPC, TTT, nSelected);
		int nMercPaysHowMuch = GetListInt(oPC, TTT, nSelected);
		float fMax = GetListFloat(oPC, TTT, nSelected);

		if ( bLimitedMoney && nMercMoney < nMercPaysHowMuch ) {
			SpeakString(sTextMercNoMoney);

		} else {
			// take item away
			object oThing = GetItemResRefPossessedBy(oPC, sSellsWhat);
			if ( !GetIsObjectValid(oThing) ) {

				SendMessageToPC(oPC, "Von dieser Ware hast du nichts zu verkaufen.");

			} else {
				if ( GetItemStackSize(oThing) > 1 ) {
					SetItemStackSize(oThing, GetItemStackSize(oThing) - 1);
				} else {
					// count
					//ActionTakeItem(oThing, oPC);
					DestroyObject(oThing);
					SetLocalString(oPC, "merc_last_sell", sSellsWhat);
				}

				// update DB
				if ( 0.0 != fMax )
					SQLQuery(
						"update merchant_inventory set cur = cur + 1 where merchant = (select id from merchants where tag = "
						+ sMerc + " limit 1) and resref = " + SQLEscape(sSellsWhat) + " limit 1;");

				if ( bLimitedMoney )
					SQLQuery("update merchants set money = money - " +
						IntToString(nMercPaysHowMuch) + " where tag = " + sMerc + " limit 1;");

				audit("sell", oPC, audit_fields("merchant", GetTag(oMerc), "resref", sSellsWhat, "price",
						IntToString(nMercPaysHowMuch)), "merchant");

				// give player the muneeh
				GiveMoneyToCreature(oPC, Value2Money(nMercPaysHowMuch));
			}
		}
	}



	MakeMerchantDialog(oPC, oMerc);
}

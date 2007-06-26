#include "_gen"
#include "inc_mysql"
#include "inc_lists"
#include "inc_currency"


const string TTT = "merc";

void MakeMerchantDialog(object oPC, object oMerc) {
	ClearList(oPC, TTT);

	int nMenuLevel0 = GetMenuLevel(oPC, TTT, 0);
	int nSelected   = GetListSelection(oPC);



	string sTag = GetStringLowerCase(GetTag(oMerc));
	string sMerc = SQLEscape(sTag);


	SQLQuery(
		"select text_intro,text_buy,text_sell,text_nothingtobuy,text_nothingtosell,money,appraise_dc,money_limited from merchants where tag = "
		+ sMerc + " limit 1;");

	if ( !SQLFetch() ) {
		SendMessageToPC(oPC,
			"Bug. :/ Kein Haendler mit diesem tag gefunden, aber NPC hat Script dran. Hm, hm. Datenbank offski?");
		return;
	}


	string sTextIntro = SQLGetData(1),
		   sTextBuy = SQLGetData(2),
		   sTextSell = SQLGetData(3),
		   sTextNothingToBuy = SQLGetData(4),
		   sTextNothingToSell = SQLGetData(5),
		   sText = "";

	int nMercMoney = StringToInt(SQLGetData(6)),
		nAppraiseDC = StringToInt(SQLGetData(7)),
		bLimitedMoney = StringToInt(SQLGetData(8));


	float fAppraiseMod = GetLocalFloat(oPC, TTT + "_" + sTag);
	if ( fAppraiseMod == 0.0 ) {
		fAppraiseMod = 1.0;

		if ( nAppraiseDC > 0 ) {
			int nD = d20() + GetSkillRank(SKILL_APPRAISE, oPC);

			fAppraiseMod += ( nD - nAppraiseDC ) * 0.01;

			if ( GetIsDM(oPC) ) {
				SendMessageToPC(oPC, "Your appraise modificator for this merchant is: " +
					FloatToString(fAppraiseMod) + " (because you rolled  a " + IntToString(nD) + ")");
			}

			SetLocalFloat(oPC, TTT + "_" + sTag, fAppraiseMod);
		}
	}


	int nPCMoney = Money2Value(CountCreatureMoney(oPC, 0));


	// Decay all bleedin items.
	SQLQuery("update merchant_inventory set last_decay = unix_timestamp() where last_decay = 0;");
	SQLQuery("update merchant_inventory set last_gain = unix_timestamp() where last_gain = 0;");

	SQLQuery(
		"update merchant_inventory set cur = if(cur - floor( (unix_timestamp() - last_decay)/60/60 * decay ) >= min, cur - floor( (unix_timestamp() - last_decay)/60/60 * decay ), min) , last_decay = unix_timestamp() where last_decay > 0 and decay != 0 and "
		+
		"cur > min and cur >= floor( (unix_timestamp() - last_decay)/60/60 * decay) and " +
		"merchant = (select id from merchants where tag = " + sMerc + " limit 1);");

	SQLQuery(
		"update merchant_inventory set cur = if(cur + floor( (unix_timestamp() - last_gain)/60/60 * gain ) <= max, cur + floor( (unix_timestamp() - last_gain)/60/60 * gain ), max) , last_gain = unix_timestamp() where last_gain > 0 and gain != 0 and "
		+
		"cur < max and cur < floor( (unix_timestamp() - last_gain)/60/60 * gain) and " +
		"merchant = (select id from merchants where tag = " + sMerc + " limit 1);");


	// SQLQuery("update merchant_inventory set cur = max where cur > max;");

	// Main menue.
	if ( 0 == nMenuLevel0 ) {
		// buy
		AddListItem(oPC, TTT, "Dinge vom Haendler kaufen");
		SetListInt(oPC, TTT, 1);

		// sell
		AddListItem(oPC, TTT, "Dinge an den Haendler verkaufen");
		SetListInt(oPC, TTT, 2);
		
		AddListItem(oPC, TTT, "Dinge mit dem Haendler tauschen");
		SetListInt(oPC, TTT, 3);


		ResetConvList(oPC, oPC, TTT, 50000, "merchant_cb", sTextIntro);

		// Buy from merchant
	} else if ( 1 == nMenuLevel0 ) {
		int nFound = 0, nCount = -1, nWant, nMax;
		string sResRef = "";
		object oSell;
		int nPrice;
		float fMark;

		SQLQuery(
			"select resref,cur,(merchant_inventory.sell_markdown * (select sell_markdown from merchants where tag="
			+ sMerc +
			")),max from merchant_inventory where sell = 1 and ((cur > 0 and cur > min) or (cur = 0 and max = 0 and min = 0)) and merchant = "
			+
			"(select id from merchants where tag = " + sMerc + " limit 1) order by resref asc;");

		while ( SQLFetch() ) {
			sResRef = SQLGetData(1);
			nWant = StringToInt(SQLGetData(2));
			nMax  = StringToInt(SQLGetData(4));

			fMark = StringToFloat(SQLGetData(3));

			oSell = GetItemResRefPossessedBy(oMerc, sResRef);
			if ( !GetIsObjectValid(oSell) )
				oSell = CreateItemOnObject(sResRef, oMerc, 1, sResRef);

			SetPlotFlag(oSell, FALSE);

			nPrice = FloatToInt(( 1.0 / fAppraiseMod ) *
						 fMark * ( GetGoldPieceValue(oSell) / GetItemStackSize(oSell) ));

			AddListItem(oPC, TTT, GetName(oSell) +
				( nMax == 0 ? " (gut bestockt)" : " (" + IntToString(nWant) + " auf Lager)" ) +
				": " + MoneyToString(Value2Money(nPrice)));
			SetListString(oPC, TTT, sResRef);
			SetListInt(oPC, TTT, nPrice);
			SetListFloat(oPC, TTT, IntToFloat(nMax));

			if ( nPrice < nPCMoney )
				SetListDisplayMode(oPC, TTT, DISPLAYMODE_GREEN);
			else
				SetListDisplayMode(oPC, TTT, DISPLAYMODE_RED);

			nFound += 1;
		}

		if ( !nFound )
			sText = sTextNothingToSell;
		else
			sText = sTextSell;


		ResetConvList(oPC, oPC, TTT, 50000, "merchant_cb", sText, "", "", "merchant_b2m0",
			"Zurueck zur Liste");


		// Sell to merchant.
	} else if ( 2 == nMenuLevel0 ) {

		int nFound = 0, nCount = -1, nWant, nMax;
		string sResRef = "";
		object oSell;
		int nPrice = 0;
		int nAvailable;
		float fMark;

		SQLQuery(
			"select resref,(merchant_inventory.buy_markup * (select buy_markup from merchants where tag=" +
			sMerc +
			")),cur,max from merchant_inventory where buy = 1 and ((cur < max) or (min=0 and cur=0 and max=0)) and merchant = "
			+
			"(select id from merchants where tag = " + sMerc + " limit 1) order by resref asc;");

		while ( SQLFetch() ) {
			sResRef = SQLGetData(1);
			fMark = StringToFloat(SQLGetData(2));
			nWant = StringToInt(SQLGetData(3));
			nMax  = StringToInt(SQLGetData(4));
			
			nCount = GetItemCountByResRef(oPC, sResRef);

			nAvailable = 1;

			oSell = GetItemResRefPossessedBy(oPC, sResRef);

			// Do not sell non-existant items
			if ( nCount == 0 )
				nAvailable = 0;

			// avoid bug thing
			if ( nCount == 1 && GetLocalString(oPC, "merc_last_sell") == sResRef ) {
				DeleteLocalString(oPC, "merc_last_sell");
				nCount -= 1;
				nAvailable = 0;
			}

			// oops?
			if ( !GetIsObjectValid(oSell) ) {
				nAvailable = 0;
				oSell = CreateItemOnObject(sResRef, oMerc);
			}

			if (!GetIsObjectValid(oSell)) {
				ToPC("Kann kein Item mit dieser ResRef erstellen (" + sResRef + "). Dies ist ein Bug. Bitte melde ihn den SLs.");
				continue;
			}
			
			nPrice = FloatToInt(fAppraiseMod * fMark * ( GetGoldPieceValue(oSell) / GetItemStackSize(oSell) ));

			AddListItem(oPC, TTT, GetName(oSell) +
				( nMax ==
				 0 ? " (immer gesucht)" : " (" +
				 IntToString(nCount) + " im Inventar, " + IntToString(nMax - nWant) + " gesucht)" ) +
				": " + MoneyToString(Value2Money(nPrice)));
			SetListString(oPC, TTT, sResRef);
			SetListInt(oPC, TTT, nPrice);
			SetListFloat(oPC, TTT, IntToFloat(nMax));

			if ( nAvailable && (!bLimitedMoney || nPrice < nMercMoney) )
				SetListDisplayMode(oPC, TTT, DISPLAYMODE_GREEN);
			else
				SetListDisplayMode(oPC, TTT, DISPLAYMODE_RED);

			nFound += 1;
		}


		if ( !nFound ) {
			sText = sTextNothingToBuy; // "Ihr habt nichts fuer das ich mich interessiere.";
		} else {
			sText = sTextBuy; //"Waehle den Gegenstand, den du verkaufen moechtest. Pro Klick wird einer verkauft.";
		}

		ResetConvList(oPC, oPC, TTT, 50000, "merchant_cb", sText, "", "", "merchant_b2m0",
			"Zurueck zur Liste");
	
	// Swap with merchant
	} else if ( 3 == nMenuLevel0 ) {

		
		string
			sTakesR, sGivesR;

		int	takesC, givesC,
		min,cur,max;

		SQLQuery(
			"select takes_resref, takes_count, gives_resref, gives_count, min, cur, max from merchant_inventory_exchange where " +
			"merchant_id = (select id from merchants where tag = " + sMerc + " limit 1) order by takes_resref asc;");

		while ( SQLFetch() ) {
			sTakesR = SQLGetData(1);
			sGivesR = SQLGetData(3);
			takesC = StringToInt(SQLGetData(2));
			givesC = StringToInt(SQLGetData(4));
			min = StringToInt(SQLGetData(5));
			min = StringToInt(SQLGetData(6));
			min = StringToInt(SQLGetData(7));


			nCount = GetItemCountByResRef(oPC, sTakesR);

			nAvailable = 1;

			oSell = GetItemResRefPossessedBy(oPC, sTakesR);

			// Do not swap non-existant items
			if ( nCount == 0 )
				nAvailable = 0;

			// avoid bug thing
			if ( nCount == takesC && GetLocalString(oPC, "merc_last_swap") == sResRef ) {
				DeleteLocalString(oPC, "merc_last_swap");
				nCount -= takesC;
				nAvailable = 0;
			}

			// oops?
			if ( !GetIsObjectValid(oSell) ) {
				nAvailable = 0;
				oSell = CreateItemOnObject(sTakesC, oMerc);
			}

			if (!GetIsObjectValid(oSell)) {
				ToPC("Kann kein Item mit dieser ResRef erstellen (" + sResRef + "). Dies ist ein Bug. Bitte melde ihn den SLs.");
				continue;
			}
			
			nPrice = FloatToInt(fAppraiseMod * fMark * ( GetGoldPieceValue(oSell) / GetItemStackSize(oSell) ));

			AddListItem(oPC, TTT, GetName(oSell) +
				( nMax ==
				 0 ? " (immer gesucht)" : " (" +
				 IntToString(nCount) + " im Inventar, " + IntToString(nMax - nWant) + " gesucht)" ) +
				": " + MoneyToString(Value2Money(nPrice)));
			SetListString(oPC, TTT, sResRef);
			SetListInt(oPC, TTT, nPrice);
			SetListFloat(oPC, TTT, IntToFloat(nMax));

			if ( nAvailable && (!bLimitedMoney || nPrice < nMercMoney) )
				SetListDisplayMode(oPC, TTT, DISPLAYMODE_GREEN);
			else
				SetListDisplayMode(oPC, TTT, DISPLAYMODE_RED);

			nFound += 1;
		}


		if ( !nFound ) {
			sText = sTextNothingToBuy; // "Ihr habt nichts fuer das ich mich interessiere.";
		} else {
			sText = sTextBuy; //"Waehle den Gegenstand, den du verkaufen moechtest. Pro Klick wird einer verkauft.";
		}

		ResetConvList(oPC, oPC, TTT, 50000, "merchant_cb", sText, "", "", "merchant_b2m0",
			"Zurueck zur Liste");
	}

}

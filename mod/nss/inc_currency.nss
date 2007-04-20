struct Money {
	int copper;
	int silver;
	int gold;
	int platinum;
};


string MoneyToString(struct Money m);


object GetMoneyBag(object oPC);

void AdjustCreatureMoney(object oPC, struct Money stDifference);

struct Money Value2Money(int iValue, int iBestCoinage = TRUE);

int Money2Value(struct Money stCoins);

struct Money CountCreatureMoney(object oPC, int iDestroy = FALSE);

void GiveValueToCreature(object oPC, int iValue, int iBestCoinage = TRUE);

void TakeValueFromCreature(int iValue, object oPC, int bDestroy = FALSE);


void GiveMoneyToCreature(object oPC, struct Money stCoins);

//

string MoneyToString(struct Money m) {
	string r = "";
	if ( m.platinum > 0 )
		r += IntToString(m.platinum) + " Platin ";
	if ( m.gold > 0 )
		r += IntToString(m.gold) + " Gold ";
	if ( m.silver > 0 )
		r += IntToString(m.silver) + " Silber ";
	if ( m.copper > 0 )
		r += IntToString(m.copper) + " Kupfer ";

	if ("" == r)
		r = "(Keine Summe angegeben) ";

	return GetStringLeft(r, GetStringLength(r) - 1);
}

object GetMoneyBag(object oPC) {
	object oItem = GetFirstItemInInventory(oPC);
	while ( GetIsObjectValid(oItem) ) {
		string sTag = GetTag(oItem);
		if ( sTag == "Muenzbeutel" && GetFirstItemInInventory(oItem) == OBJECT_INVALID ) {
			SendMessageToPC(oPC, GetName(oItem));
			return oItem;
		}
		oItem = GetNextItemInInventory(oPC);
	}
	return oPC;
}

int AdjustObject(object oMoneyBag, object oWhat, int iDifference) {
	int iStack = GetItemStackSize(oWhat);

	if ( iDifference < 0 ) {
		if ( -iDifference >= iStack ) {
			DestroyObject(oWhat);
			return iDifference + iStack;
		} else {
			SetItemStackSize(oWhat, iDifference + iStack);
			return 0;
		}
	} else {
		while ( iDifference > 500 ) {
			CreateItemOnObject(GetStringLowerCase(GetTag(oWhat)), oMoneyBag, 500);
			iDifference -= 500;
		}
		if ( iDifference )
			CreateItemOnObject(GetStringLowerCase(GetTag(oWhat)), oMoneyBag, iDifference);
		return 0;
	}
}


void AdjustCreatureMoney(object oPC, struct Money stDifference) {
	object oMoneyBag = GetMoneyBag(oPC);
	object oItem = GetFirstItemInInventory(oPC);

	while ( GetIsObjectValid(oItem) ) {
		string sTag = GetTag(oItem);

		if ( sTag == "COIN_0001" )
			stDifference.copper = AdjustObject(oMoneyBag, oItem, stDifference.copper);
		else if ( sTag == "COIN_0010" )
			stDifference.silver = AdjustObject(oMoneyBag, oItem, stDifference.silver);
		else if ( sTag == "COIN_0100" )
			stDifference.gold = AdjustObject(oMoneyBag, oItem, stDifference.gold);
		else if ( sTag == "COIN_1000" )
			stDifference.platinum = AdjustObject(oMoneyBag, oItem, stDifference.platinum);
		oItem = GetNextItemInInventory(oPC);
	}
	/* Remainings are positive and no matching item found */
	if ( stDifference.copper > 0 )
		CreateItemOnObject("coin_0001", oMoneyBag, stDifference.copper);
	if ( stDifference.silver > 0 )
		CreateItemOnObject("coin_0010", oMoneyBag, stDifference.silver);
	if ( stDifference.gold > 0 )
		CreateItemOnObject("coin_0100", oMoneyBag, stDifference.gold);
	if ( stDifference.platinum > 0 )
		CreateItemOnObject("coin_1000", oMoneyBag, stDifference.platinum);
}


struct Money Value2Money(int iValue, int iBestCoinage = TRUE) {
	struct Money New;

	New.platinum = iValue / 1000;
	if ( !iBestCoinage ) New.platinum = Random(New.platinum + 1);
	iValue -= New.platinum * 1000;

	New.gold = iValue / 100;
	if ( !iBestCoinage ) New.gold = Random(New.gold + 1);
	iValue -= New.gold * 100;

	New.silver = iValue / 10;
	if ( !iBestCoinage ) New.silver = Random(New.silver + 1);
	iValue -= New.silver * 10;

	New.copper = iValue;

	return New;
}

int Money2Value(struct Money stCoins) {
	return stCoins.platinum * 1000 + stCoins.gold * 100 + stCoins.silver * 10 +
		   stCoins.copper;
}

struct Money CountCreatureMoney(object oPC, int iDestroy = FALSE) {
	struct Money stSum;
	object oItem = GetFirstItemInInventory(oPC);

	while ( GetIsObjectValid(oItem) ) {
		string sTag = GetTag(oItem);

		if ( sTag == "COIN_1000" ) {
			stSum.platinum += GetItemStackSize(oItem);
			if ( iDestroy ) DestroyObject(oItem);
		} else if ( sTag == "COIN_0100" ) {
			stSum.gold += GetItemStackSize(oItem);
			if ( iDestroy ) DestroyObject(oItem);
		} else if ( sTag == "COIN_0010" ) {
			stSum.silver += GetItemStackSize(oItem);
			if ( iDestroy ) DestroyObject(oItem);
		} else if ( sTag == "COIN_0001" ) {
			stSum.copper += GetItemStackSize(oItem);
			if ( iDestroy ) DestroyObject(oItem);
		}
		oItem = GetNextItemInInventory(oPC);
	}
	return stSum;
}

int GetValue(object oPC) {
	return Money2Value(CountCreatureMoney(oPC));
}

void GiveMoneyToCreature(object oPC, struct Money stCoins) {
	object oMoneyBag = GetMoneyBag(oPC);
	int iBatch;

	iBatch = stCoins.platinum;
	while ( iBatch ) {
		if ( iBatch > 500 ) {
			CreateItemOnObject("coin_1000", oMoneyBag, 500);
			iBatch -= 500;
		} else {
			CreateItemOnObject("coin_1000", oMoneyBag, iBatch);
			iBatch = 0;
		}
	}

	iBatch = stCoins.gold;
	while ( iBatch ) {
		if ( iBatch > 500 ) {
			CreateItemOnObject("coin_0100", oMoneyBag, 500);
			iBatch -= 500;
		} else {
			CreateItemOnObject("coin_0100", oMoneyBag, iBatch);
			iBatch = 0;
		}
	}

	iBatch = stCoins.silver;
	while ( iBatch ) {
		if ( iBatch > 500 ) {
			CreateItemOnObject("coin_0010", oMoneyBag, 500);
			iBatch -= 500;
		} else {
			CreateItemOnObject("coin_0010", oMoneyBag, iBatch);
			iBatch = 0;
		}
	}

	iBatch = stCoins.copper;
	while ( iBatch ) {
		if ( iBatch > 500 ) {
			CreateItemOnObject("coin_0001", oMoneyBag, 500);
			iBatch -= 500;
		} else {
			CreateItemOnObject("coin_0001", oMoneyBag, iBatch);
			iBatch = 0;
		}
	}
}

void GiveValueToCreature(object oPC, int iValue, int iBestCoinage = TRUE) {
	GiveMoneyToCreature(oPC, Value2Money(iValue, iBestCoinage));
}

void TakeValueFromCreature(int iValue, object oPC, int bDestroy = FALSE) {
	struct Money stDifference = CountCreatureMoney(oPC);

	struct Money stAmount = stDifference;

	stAmount.copper -= iValue;

	if ( stAmount.copper < 0 ) {
		stAmount.silver += stAmount.copper / 10;
		stAmount.copper = stAmount.copper % 10;

		if ( stAmount.copper < 0 ) {
			stAmount.silver--;
			stAmount.copper += 10;
		}
	}

	if ( stAmount.silver < 0 ) {
		stAmount.gold += stAmount.silver / 10;
		stAmount.silver = stAmount.silver % 10;

		if ( stAmount.silver < 0 ) {
			stAmount.gold--;
			stAmount.silver += 10;
		}
	}

	if ( stAmount.gold < 0 ) {
		stAmount.platinum += stAmount.gold / 10;
		stAmount.gold = stAmount.gold % 10;

		if ( stAmount.gold < 0 ) {
			stAmount.platinum--;
			stAmount.gold += 10;
		}
	}

	stDifference.copper = stAmount.copper - stDifference.copper;
	stDifference.silver = stAmount.silver - stDifference.silver;
	stDifference.gold = stAmount.gold - stDifference.gold;
	stDifference.platinum = stAmount.platinum - stDifference.platinum;

	AdjustCreatureMoney(oPC, stDifference);

	if ( !bDestroy )
		GiveValueToCreature(OBJECT_SELF, iValue, TRUE);
}



// The player has enough rent money?

#include "inc_currency"

#include "inc_horse"

int StartingConditional() {
	int nMuneeh = Money2Value(CountCreatureMoney(GetPCSpeaker()));

	object oStableBoy = OBJECT_SELF;

	float fRent = GetLocalFloat(OBJECT_SELF, "rent_per_day");
	if ( 0.0 == fRent )
		fRent = DAILY_RENT;


	struct Rideable r = GetRideable(GetPCSpeaker());

	int nNeedMuneeh = GetRideableRentCost(r, fRent);

	return nMuneeh >= nNeedMuneeh;
}

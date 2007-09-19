// Pay the rent, then spawn the horse.

#include "inc_horse"

void main() {
	object oPC = GetPCSpeaker();
	string sStall = GetTag(OBJECT_SELF);

	struct Rideable r = GetRideable(oPC);

	if ( GetIsValidRideable(r) ) {
		if ( r.stable == sStall ) {
			int nType;

			if ( r.type == "Pony" ) {
				nType = HORSETYPE_PONY;
			} else {
				nType = HORSETYPE_HORSE;
			}

			// pay up!
			float fRent = GetLocalFloat(OBJECT_SELF, "rent_per_day");
			if ( 0.0 == fRent )
				fRent = DAILY_RENT;

			int nMuneeh = GetRideableRentCost(r, fRent);

			if ( nMuneeh > 0 )
				TakeValueFromCreature(nMuneeh, oPC, TRUE);


			r.stable = "";
			SetRideable(r);

			SpawnHorse(nType, r.phenotype, oPC, r.name);

		} else {
			SendMessageToPC(oPC, "Falscher Stall!");
		}


	} else
		SendMessageToPC(oPC, "Ihr besitzt kein Pferd oder Pony!");
}

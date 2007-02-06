#include "inc_mysql"
#include "inc_cdb"

struct Rideable {
	int id;

	int cid;
	string stable;
	string type;
	int phenotype;
	string name;

	// ig-year + ig-month + ig_day + ig_hour
	int delivered_in_day;
	int delivered_in_hour;
	int delivered_in_month;
	int delivered_in_year;

	// Bought the ruddy thing?
	int bought;

	// Does this rideable need paying?
	int pay_rent;
};




int GetIsValidRideable(struct Rideable r);
struct Rideable GetRideable(object oPC);
struct Rideable SetRideable(struct Rideable r);

// Updates the timestamp with the current time.
struct Rideable SetRideableDeliveredIn(struct Rideable r);

int GetIsValidRideable(struct Rideable r) {
	return r.id > 0;
}


// Returns how much r costs to retrieve.
int GetRideableRentCost(struct Rideable r, float fPerDay);



int GetRideableRentCost(struct Rideable r, float fPerDay) {
	if ( 0 == r.delivered_in_year )
		return 0;

	if ( !r.pay_rent )
		return 0;

	int nRet =
		FloatToInt(fPerDay * IntToFloat(
				( GetCalendarDay() - r.delivered_in_day ) +
				( GetCalendarMonth() - r.delivered_in_month ) * 30 +
				( GetCalendarYear() - r.delivered_in_year ) * 30 * 12
			)
		);

	// Dont bill less than 5 copper (about 2 hours)
	// dont bill negative delays
	if ( nRet < 5 )
		nRet = 0;

	return nRet;
}


struct Rideable SetRideableDeliveredIn(struct Rideable r) {
	r.delivered_in_hour = GetTimeHour();
	r.delivered_in_day = GetCalendarDay();
	r.delivered_in_month = GetCalendarMonth();
	r.delivered_in_year = GetCalendarYear();
	return r;
}


struct Rideable GetRideable(object oPC) {
	int nCID = GetCharacterID(oPC);
	struct Rideable r;
	SQLQuery(
		"select `id`,`character`,`stable`,`type`,`phenotype`,`name`,`delivered_in_hour`, `delivered_in_day`, `delivered_in_month`, `delivered_in_year` ,`bought`, `pay_rent` from `rideables` where `character`="
		+ IntToString(nCID) + " limit 1;");
	if ( SQLFetch() ) {
		r.id = StringToInt(SQLGetData(1));
		r.cid = nCID;
		r.stable = SQLGetData(3);
		r.type = SQLGetData(4);
		r.phenotype = StringToInt(SQLGetData(5));
		r.name = SQLGetData(6);
		r.delivered_in_hour = StringToInt(SQLGetData(7));
		r.delivered_in_day = StringToInt(SQLGetData(8));
		r.delivered_in_month = StringToInt(SQLGetData(9));
		r.delivered_in_year = StringToInt(SQLGetData(10));
		r.bought = StringToInt(SQLGetData(11));
		r.pay_rent = StringToInt(SQLGetData(12));
	}

	return r;
}

struct Rideable SetRideable(struct Rideable r) {
	if ( !GetIsValidRideable(r) )
		return r;

	SQLQuery("select `id` from `rideables` where `id`=" + IntToString(r.id) + " limit 1;");
	if ( SQLFetch() ) {
		SQLQuery("update `rideables` set " +
			"`stable`=" + SQLEscape(r.stable) + ", " +
			"`type`=" + SQLEscape(r.type) + ", " +
			"`phenotype`=" + IntToString(r.phenotype) + ", " +
			"`name`=" + SQLEscape(r.name) + ", " +
			"`delivered_in_hour`=" + IntToString(r.delivered_in_hour) + ", " +
			"`delivered_in_day`=" + IntToString(r.delivered_in_day) + ", " +
			"`delivered_in_month`=" + IntToString(r.delivered_in_month) + ", " +
			"`delivered_in_year`=" + IntToString(r.delivered_in_year) + ", " +
			"`bought`=" + IntToString(r.bought) + ", " +
			"`pay_rent`=" + IntToString(r.pay_rent) +
			" where `id`=" + IntToString(r.id) + " limit 1;");
	} else {
		SQLQuery(
			"insert into `rideables` (`character`,`stable`,`type`,`phenotype`,`name`,`delivered_in_hour`,`delivered_in_day`,`delivered_in_month`,`delivered_in_year`,`bought`,`pay_rent`) values("
			+
			IntToString(r.cid) +
			", " + SQLEscape(r.stable) + ", " + SQLEscape(r.type) + ", " + IntToString(r.phenotype) + ", " +
			SQLEscape(r.name) +
			", " +
			IntToString(r.delivered_in_hour) +
			", " +
			IntToString(r.delivered_in_day) +
			", " + IntToString(r.delivered_in_month) + ", " + IntToString(r.delivered_in_year) + ", " +
			IntToString(r.bought) + ", " + IntToString(r.pay_rent) + ");");
		SQLQuery("select `id` from `rideables` oder by `id` desc limit 1;");
		SQLFetch();
		r.id = StringToInt(SQLGetData(1));
	}
	return r;
}

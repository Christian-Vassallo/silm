// Hasnt paid the rent for this month
#include "inc_horse_data"

int StartingConditional() {
	struct Rideable r = GetRideable(GetPCSpeaker());

	int nMonth = StringToInt(IntToString(GetCalendarYear()) + IntToString(GetCalendarDay()));

	return 0; // r.last_month_paid < nMonth;
}

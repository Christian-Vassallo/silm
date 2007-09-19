#include "inc_currency"

int StartingConditional() {
	return GetValue(GetPCSpeaker()) >= GetLocalInt(OBJECT_SELF, "PRICE");

}

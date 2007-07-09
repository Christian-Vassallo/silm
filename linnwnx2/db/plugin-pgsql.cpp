#include "NWNXpgsql.h"

CNWNXpgsql ppgsql;

extern "C" {
CNWNXBase* GetClassObject()
{
	return &ppgsql;
}
}

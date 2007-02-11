#include "NWNXruby.h"

CNWNXruby ruby;

extern "C" {
	CNWNXBase* GetClassObject() {
		return &ruby;
	}
}

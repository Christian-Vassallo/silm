/* Unified targeting device */
#include "inc_getopt"
#include "_gen"

const int
TARGET_MAX = 11,
TARGET_DEFAULT_SLOT = -1,
TARGET_MACRO_SLOT = 11;



location GetTargetLocation(int nSlot = TARGET_DEFAULT_SLOT, object oPC = OBJECT_SELF);

object GetTarget(int nSlot = TARGET_DEFAULT_SLOT, object oPC = OBJECT_SELF);

void SetTarget(object oTarget, int nSlot = TARGET_DEFAULT_SLOT, object oPC = OBJECT_SELF);

void SetTargetLocation(location lTarget, int nSlot = TARGET_DEFAULT_SLOT, object oPC = OBJECT_SELF);

int GetDefaultSlot(object oPC = OBJECT_SELF);

void SetDefaultSlot(int nSlot, object oPC = OBJECT_SELF);

int GetTargetSlot(object oPC = OBJECT_SELF);

int NotifyBadTarget(string sAddMsg = "", object oPC = OBJECT_SELF);


// impl


int SanitiseSlot(int n, object oPC = OBJECT_SELF) {
	if ( n == TARGET_DEFAULT_SLOT )
		return GetDefaultSlot(oPC);

	if ( n < 1 || n > TARGET_MAX )
		return 1;
	else
		return n;
}

location GetTargetLocation(int nSlot = TARGET_DEFAULT_SLOT, object oPC = OBJECT_SELF) {
	nSlot = SanitiseSlot(nSlot);
	return GetLocalLocation(oPC, "use_target_location_" + IntToString(nSlot));
}

object GetTarget(int nSlot = TARGET_DEFAULT_SLOT, object oPC = OBJECT_SELF) {
	if ( opt("t") ) {
		nSlot = StringToInt(optv("t"));
	}

	nSlot = SanitiseSlot(nSlot);

	return GetLocalObject(oPC, "use_target_object_" + IntToString(nSlot));
}

void SetTarget(object oTarget, int nSlot = TARGET_DEFAULT_SLOT, object oPC = OBJECT_SELF) {
	nSlot = SanitiseSlot(nSlot);
	SetLocalObject(oPC, "use_target_object_" + IntToString(nSlot), oTarget);
	SendMessageToPC(oPC, "O[" +
		IntToString(nSlot) +
		"]: '" +
		GetName(oTarget) +
		"', Tag: " +
		GetTag(oTarget) +
		", ResRef: " +
		GetResRef(oTarget) +
		", OID: " + ObjectToString(oTarget) + ", " + ObjectTypeToString(GetObjectType(oTarget)));
	SendMessageToPC(oPC, "O[" + IntToString(nSlot) + "]: " + LocationToStringPrintable(GetLocation(oTarget)));
	// Distance: " + FloatToString(GetDistanceBetween(oPC, oTarget)));
}

void SetTargetLocation(location lTarget, int nSlot = TARGET_DEFAULT_SLOT, object oPC = OBJECT_SELF) {
	nSlot = SanitiseSlot(nSlot);
	SetLocalLocation(oPC, "use_target_location_" + IntToString(nSlot), lTarget);
	SendMessageToPC(oPC, "L[" + IntToString(nSlot) + "]: " + LocationToStringPrintable(lTarget));
	SendMessageToPC(oPC, "L[" +
		IntToString(nSlot) +
		"] Distance: " + FloatToString(GetDistanceBetweenLocations(GetLocation(oPC), lTarget)));
}


int NotifyBadTarget(string sAddMsg = "", object oPC = OBJECT_SELF) {
	if ( sAddMsg == "" )
		SendMessageToPC(oPC, "Invalid target.");
	else
		SendMessageToPC(oPC, "Invalid target: " + sAddMsg + ".");

	return 3; // FAIL in inc_chat_lib
}

int GetTargetSlot(object oPC = OBJECT_SELF) {
	if ( opt("t") )
		return SanitiseSlot(StringToInt(optv("t")));
	else
		return GetDefaultSlot();
}

int GetDefaultSlot(object oPC = OBJECT_SELF) {
	return GetLocalInt(oPC, "use_target_slot") != 0 ? GetLocalInt(oPC, "use_target_slot") : 1;
}

void SetDefaultSlot(int nSlot, object oPC = OBJECT_SELF) {
	nSlot = SanitiseSlot(nSlot);
	SetLocalInt(oPC, "use_target_slot", nSlot);
	SendMessageToPC(oPC, "Default slot set to " + IntToString(nSlot) + ".");
}


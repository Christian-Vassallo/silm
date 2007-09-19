#include "_gen"



void SingleUse();


void UseCharge(int nCharges = 1);

// Returns true if used on himself
int SelfOnly();


void NothingHappens();

// Allow only one item effect on oTarget at a time.
// Returns true if the user is allowed to use this herb.
int OneAtATime(object oTarget, float fDuration);

void main() {
	object
	oPC = GetItemActivator(),
	oItem = OBJECT_SELF,
	oTarget = GetItemActivatedTarget();
	string
	sTag = GetTag(oItem);

	location
	lTarget = GetItemActivatedTargetLocation();

	if ( GetItemCharges(oItem) > 0 )
		SetItemCharges(oItem, GetItemCharges(oItem) + 1);


	float fDuration = 5.0 * 30.0;
	fDuration += ( -60.0 + IntToFloat(Random(120)) );

	string sItem = GetStringRight(sTag, GetStringLength(sTag) - 2 /* "c_" */);

	if ( "fireoil" == sItem ) {} else if ( "" == sItem ) {} //else
															//;
															//NothingHappens();



}


void UseCharge(int nCharges = 1) {
	if ( GetItemCharges(OBJECT_SELF) > 0 )
		SetItemCharges(OBJECT_SELF, GetItemCharges(OBJECT_SELF) - nCharges);
}


void NothingHappens() {
	object oPC = GetItemActivator();
	Floaty("Nichts passiert.", oPC, 0);
}


int OneAtATime(object oTarget, float fDuration) {
	object
	oHerb = OBJECT_SELF;
	string
	sTag = GetTag(oHerb);

	if ( GetLocalInt(oTarget, "f_" + sTag) )
		return 0;
	else {
		SetLocalInt(oTarget, "f_" + sTag, 1);
		DelayCommand(fDuration, DeleteLocalInt(oTarget, "f_" + sTag));
		return 1;
	}
}


void SingleUse() {
	if ( GetItemStackSize(OBJECT_SELF) > 1 )
		SetItemStackSize(OBJECT_SELF, GetItemStackSize(OBJECT_SELF) - 1);
	else
		DestroyObject(OBJECT_SELF);
}


int SelfOnly() {
	object
	oPC = GetItemActivator(),
	oTarget = GetItemActivatedTarget();

	if ( oTarget != oPC ) {
		Floaty("Ihr koennt diesen Gegenstand nur auf Euch selbst benutzen.", oPC);
		return 0;
	}

	return 1;
}




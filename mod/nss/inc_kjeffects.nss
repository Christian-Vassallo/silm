//
// Direkttriggerung eines Effektes auf den Ort eines Objekts
//
void kjEffectAtObjectLocation(object _oObject, int _iEffectNo) {
	location lLoc = GetLocation(_oObject);
	ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, EffectVisualEffect(_iEffectNo), lLoc);
}


//
// Sucht in der Map alle Objekte mit der Anfangskennung _sEffectObject
// und triggert auf sie den FX-Effekt _iEffectNo (visualeffects.2da)
//
void kjLoopObjects4EffectTrigger(int _iEffectNo, string _sEffectObject) {
	object oArea = OBJECT_SELF;
	object oObject = GetFirstObjectInArea(oArea);

	while ( GetIsObjectValid(oObject) ) {
		if ( GetStringLeft(GetTag(oObject), GetStringLength(_sEffectObject)) == _sEffectObject ) {
			kjEffectAtObjectLocation(oObject, _iEffectNo);
		}
		oObject = GetNextObjectInArea(oArea);
	}
}


//
// Bezieht die Variablen iEffectNo und sEffectWP von dem Triggerobjekt und
// reicht jene weiter in den Loop über alle Objekte in der Karte
//
void kjTriggerEffectAtWP() {
	location lLoc;
	int iEffectNo = GetLocalInt(OBJECT_SELF, "EffectNo");
	string sEffectWP = GetLocalString(OBJECT_SELF, "EffectWP");

	kjLoopObjects4EffectTrigger(iEffectNo, sEffectWP);
}

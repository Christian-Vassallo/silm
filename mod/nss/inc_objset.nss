

void AddToSet(string sSetName, object oObj, object oPC = OBJECT_SELF);

object GetFromSet(string sSetName, int nIndex, object oPC = OBJECT_SELF);

int GetSetSize(string sSetName, object oPC = OBJECT_SELF);

void ClearSet(string sSetName, object oPC = OBJECT_SELF);

// Removes nIndex from set sSetName, shuffling all following
//int RemoveFromSet(string sSetName, int nIndex);

string GetCurrentSet(object oPC = OBJECT_SELF);
void SetCurrentSet(string sSetName, object oPC = OBJECT_SELF);

int GetIsInSet(string sSetName, object oTest, object oPC = OBJECT_SELF);



int GetIsInSet(string sSetName, object oTest, object oPC = OBJECT_SELF) {
	int i;
	for (i = 0; i < GetSetSize(sSetName, oPC); i++)
		if (GetFromSet(sSetName, i, oPC) == oTest)
			return 1;
	return 0;
}

void AddToSet(string sSetName, object oObj, object oPC = OBJECT_SELF) {
	object oPC = GetModule();
	int nSz = GetLocalInt(oPC, "objset_" + sSetName + "_sz");
	SetLocalObject(oPC, "objset_" + sSetName + "_" + IntToString(nSz), oObj);
	nSz++;
	SetLocalInt(oPC, "objset_" + sSetName + "_sz", nSz);
}

object GetFromSet(string sSetName, int nIndex, object oPC = OBJECT_SELF) {
	object oPC = GetModule();
	int nSz = GetLocalInt(oPC, "objset_" + sSetName + "_sz");
	if (nIndex > nSz - 1 || nIndex < 0)
		return OBJECT_INVALID;

	return GetLocalObject(oPC, "objset_" + sSetName + "_" + IntToString(nIndex));
}

int GetSetSize(string sSetName, object oPC = OBJECT_SELF) {
	object oPC = GetModule();
	int nSz = GetLocalInt(oPC, "objset_" + sSetName + "_sz");
	return nSz;
}

void ClearSet(string sSetName, object oPC = OBJECT_SELF) {
	object oPC = GetModule();
	SetLocalInt(oPC, "objset_" + sSetName + "_sz", 0);

}

string GetCurrentSet(object oPC = OBJECT_SELF) {
	return GetLocalString(oPC, "objset_current");
}

void SetCurrentSet(string sSetName, object oPC = OBJECT_SELF) {
	SetLocalString(oPC, "objset_current", sSetName);
}

/*int RemoveFromSet(string sSetName, int nIndex) {
	object oPC = GetModule();
	int nSz = GetLocalInt(oPC, "objset_" + sSetName + "_sz");
	if (nIndex > nSz - 1 || nIndex < 0)
		return 0;
	SetLocalObject(oPC, "objset_" + sSetName + "_" + IntToString(nIndex), OBJECT_INVALID);
	object otmp;
	int i;
	for (i = nIndex; i < nSz; i++) {
		otmp = GetLocalObject(oPC, i);
		
	}
	nSz++;
	SetLocalInt(oPC, "objset_" + sSetName + "_sz", nSz);
}*/


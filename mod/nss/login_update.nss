// Updates object oItem from oPC with new ItemTemplate sResRes
void UpdateItem(object oPC, object oItem, string sResRef);

void main() {
	int i;
	object oItem = GetFirstItemInInventory(OBJECT_SELF);
	while ( GetIsObjectValid(oItem) ) {
		if ( GetResRef(oItem) == "heilertasche" ) {
			DelayCommand(0.2 * i++, UpdateItem(OBJECT_SELF, oItem, "healerkit"));
		} else if ( GetTag(oItem) == "SUM_CARD" ) {
			DelayCommand(0.2 * i++, UpdateItem(OBJECT_SELF, oItem, GetResRef(oItem)));
		}
		oItem = GetNextItemInInventory(OBJECT_SELF);
	}
}

void UpdateItem(object oPC, object oItem, string sResRef) {
	SendMessageToPC(oPC, "ItemUpdate " + GetName(oItem) + ":");
	CreateItemOnObject(sResRef);
	DestroyObject(oItem);
}

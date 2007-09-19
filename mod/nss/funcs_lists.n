//Clears a list from the object
void ClearList(object oHolder, string sListTag);
//Returns the number of elements in the list
int GetListCount(object oHolder, string sListTag);
//Adds an item to the list. 'ListTitle' would show up in the conversation
void AddListItem(object oHolder, string sListTag, string sListTitle);
void SetListInt(object oHolder, string sListTag, int iValue);
void SetListString(object oHolder, string sListTag, string sValue);
void SetListLocation(object oHolder, string sListTag, location lValue);
void SetListObject(object oHolder, string sListTag, object oValue);
void SetListFloat(object oHolder, string sListTag, float fValue);
//With the proper dialogue tree, iDispMode > 0 means the entry is shown in green,
// < 0 means the entry is shown in red
void SetListDisplayMode(object oHolder, string sListTag, int iDispMode);
int GetListInt(object oHolder, string sListTag, int iEntry);
string GetListString(object oHolder, string sListTag, int iEntry);
location GetListLocation(object oHolder, string sListTag, int iEntry);
object GetListObject(object oHolder, string sListTag, int iEntry);
float GetListFloat(object oHolder, string sListTag, int iEntry);
int GetListDisplayMode(object oHolder, string sListTag, int iEntry);
//Start a new selection list
void ResetConvList(object oPC, object oHolder, string sListTag, int iStartToken);
//Build up the current conversation page
void BuildConvListPage(object oPC);
int HasNextPage(object oPC);
int HasPrevPage(object oPC);
void SwitchPage(object oPC, int iDirection = 0);
int GetConvListEntry(object oPC, int iIndex);


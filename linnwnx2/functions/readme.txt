NWNX Functions 1.8.1
----
New functions:
  object GetFirstArea();
  object GetNextArea();
---

virusman
15.04.2007

------------------------------------------
Complete function list:

int GetArmorAC(object oObject);
void SetArmorAC(object oObject, int iAC);
void SetGoldPieceValue(object oObject, int iValue);
void SetTag(object oObject, string sValue);
void SetRacialType(object oObject, int nRacialType);
int GetDescriptionLength(object oObject);
string GetDescription(object oObject);
string SetDescription(object oObject, string sNewDescription);
string GetConversation(object oObject);
int GetUndroppableFlag(object oItem);
void SetUndroppableFlag(object oItem, int bUndroppable);
int GetItemWeight(object oObject);
void SetItemWeight(object oObject, int nWeight);
string GetEventHandler(object oObject, int nEventId);
void SetEventHandler(object oObject, int nEventId, string sScript);
int GetFactionID(object oObject);
void SetFactionID(object oObject, int nFaction);
float GetGroundHeight(location lLocation);
int GetIsWalkable(location lLocation);
object GetFirstArea();
object GetNextArea();

------------------------------------------
Previous versions:

NWNX Functions 1.8 (08.04.2007)
----
New functions:
  float GetGroundHeight(location lLocation);
  int GetIsWalkable(location lLocation);
Updated:
  Ported faction functions to 1.68.

NWNX Functions 1.7 (15.02.2007)
----
New functions:
  int GetDescriptionLength(object oObject);
  string GetConversation(object oObject);
  int GetUndroppableFlag(object oItem);
  void SetUndroppableFlag(object oItem, int bUndroppable);
  int GetItemWeight(object oObject);
  void SetItemWeight(object oObject, int nWeight);

Updated:
  Get/SetDescription now work with doors and creatures.
  Added a bit more comments on functions
  Added plugin sources to the package

NWNX Functions 1.6 (18.09.2006)
----
New functions:
  void SetRacialType(object oObject, int iValue);
  string GetEventHandler(object oObject, int nEventId);
  void SetEventHandler(object oObject, int nEventId, string sScript);
  int GetFactionID(object oObject);
  void SetFactionID(object oObject, int nFaction);
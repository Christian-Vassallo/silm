Modified NWNX2 library (2.7 beta2) & NWNX Events plugin (version 1.1.5)

Provides hooks for the following events:
* PickPocket
  - oCreature
  - oTarget
* Attack
  - oCreature
  - oTarget
* UseItem
  - oCreature
  - oTarget
  - oItem
  - vPosition
  (this action can be blocked from script)

Provides functions for conditional and action scripts:
    int GetCurrentNodeType();
    int GetCurrentNodeID();
    int GetCurrentAbsoluteNodeID();
    string GetCurrentNodeText(int nLangID, int nGender);
    void SetCurrentNodeText(string sText, int nLangID, int nGender);
    int GetSelectedNodeID();
    int GetSelectedAbsoluteNodeID();
    string GetSelectedNodeText(int nLangID, int nGender);
See the Demo module for examples.

The default event script name is vir_events.
To set custom script name, add the following lines to your nwnx2.ini file:
--
[EVENTS]
event_script=<your script name>
--
Example script and demo module are included.

---
virusman, 14.04.2007


-----------------
CHANGELOG:

1.1.5 (14.04.2007)
- New functions for conversations:
    string GetCurrentNodeText(int nLangID, int nGender);
    void SetCurrentNodeText(string sText, int nLangID, int nGender);
    string GetSelectedNodeText(int nLangID, int nGender);

1.1.4 (11.04.2007)
- Added GetEventPosition() for UseItem event

1.1.3 (09.04.2007)
- (Minor change) Returned support for old format of function call: GETEVENTID

1.1.2 (04.04.2007)
- New functions for conversations:
    int GetSelectedNodeID();
    int GetSelectedAbsoluteNodeID();
- Removed SelectSonversationNode event: use Action scripts instead
- Added underscores to function calls
- Cleaned up the code a bit

1.1 (22.03.2007)
- New functions for conversations:
    int GetCurrentNodeType();
    int GetCurrentNodeID();
    int GetCurrentAbsoluteNodeID();
- Released the sources
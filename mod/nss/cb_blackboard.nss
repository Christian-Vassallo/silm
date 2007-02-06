#include "_gen"
#include "inc_blackboard"
#include "inc_spelltools"

void main() {
	object oPC = GetLocalObject(OBJECT_SELF, "ConvList_PC");
	int iSelPart = GetLocalInt(oPC, "bb_sel");
	int iSelection = GetLocalInt(oPC, "ConvList_Select");
	iSelection = GetListInt(oPC, "bb", iSelection);
	object oBlackBoard = GetLocalObject(OBJECT_SELF, "bb_board");

	object oPaper;
	struct BlackboardEntry r;

	// in entry?
	if ( iSelPart > 0 ) {
		// listen for sub-options
		int iSelectedNoteID = GetLocalInt(oPC, "bb_last_selected");
		r = GetBlackBoardEntry(iSelectedNoteID, oBlackBoard);

		switch ( iSelection ) {
			case 1: // Remove note
				DeleteBlackBoardEntry(oBlackBoard, iSelectedNoteID);
				Floaty("Ihr entfernt diese Notiz.", oPC, 1);
				// fall through

			case 2: // duplicate note
				// XXX: need paper!
				ToPC("Noch nicht eingebaut, sorry.", oPC);
				break;

				oPaper = GetItemPossessedBy(oPC, "c_paper");
				if ( !GetIsObjectValid(oPaper) ) {
					Floaty("Ihr benoetigt ein leeres Pergament, um diese Notiz abzuschreiben.", oPC);
				}
				//oPaper = CreateItemOnObject("c_paper", oPC);
				// Set all the local vars
				SetLocalInt(oPaper, "paper_writecycles", 1);
				SetLocalString(oPaper, "paper_text_0", r.text);
				SetLocalInt(oPaper, "paper_cid_0", r.cid);
				FixPergamentName(oPaper);
				break;

			default:
				SendMessageToPC(oPC, "Unbekannte Option.");
				break;
		}

	} else {
		// Woah. Back to menue.
		SetLocalInt(oPC, "bb_sel", iSelection);
	}

	MakeBlackBoardDialog(oPC, oBlackBoard);
}

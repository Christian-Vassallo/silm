#include "inc_events"
#include "inc_cdb"
#include "_gen"
#include "inc_spelltools"



void main() {
	if ( EVENT_ITEM_ACTIVATE != GetEvent() )
		return;

	object oWax = GetItemActivated();
	object oTarget = GetItemActivatedTarget();
	object oPC = GetItemActivator();


	if ( GetTag(oTarget) != "c_paper" ) {
		Floaty("Siegelwachs kann nur auf Pergament angewendet werden.", oPC, 0);
		return;
	}

	int
	nSigil = GetLocalInt(oTarget, "paper_sigil"),
	nSigilBroken = GetLocalInt(oTarget, "paper_sigil_broken");
	string
	sSigil = GetLocalString(oTarget, "paper_sigil_name");


	if ( nSigil && !nSigilBroken ) {
		Floaty("Dieses Pergament ist bereits versiegelt.  Brecht das Siegel zuerst, um es zu entfernen.", oPC,
			0);
		SetItemCharges(oWax, GetItemCharges(oWax) + 1);
		return;
	}

/*    if (nSigil && nSigilBroken) {
 * 		// try to fix
 * 		return;
 * 	}*/


	if ( nSigil && nSigilBroken ) {
		SetLocalInt(oTarget, "paper_sigil", 0);
		SetLocalInt(oTarget, "paper_sigil_broken", 0);
		SetLocalString(oTarget, "paper_sigil_label", "");
		Floaty(".. Ihr entfernt das alte Siegel ..", oPC, 0);
		FixPergamentName(oTarget);
		return;
	}

	string sAddText = GetLocalString(oPC, "paper_text_to_write");
	sAddText = GetStringLeft(sAddText, 64);
	SetLocalString(oTarget, "paper_sigil_label", sAddText);
	SetLocalString(oPC, "paper_text_to_write", "");

	SetLocalInt(oTarget, "paper_sigil", 1);
	SetLocalInt(oTarget, "paper_sigil_broken", 0);
	SetLocalString(oTarget, "paper_sigil_name", GetName(oPC));
	SetLocalInt(oTarget, "paper_sigil_cid", GetCharacterID(oPC));

	Floaty("Ihr versiegelt das Pergament mit Eurem Namen.", oPC, 1);

	FixPergamentName(oTarget);
}

#include "_gen"
#include "inc_events"
#include "inc_cdb"
#include "inc_spelltools"


void AddText(object oWriter, object oPaper, string sText);

void main() {

	if ( EVENT_ITEM_ACTIVATE != GetEvent() )
		return;


	object
	oPen = GetItemActivated(),
	oPC = GetItemActivator(),
	oPaper = GetItemActivatedTarget();


	string sText = GetLocalString(oPC, "paper_text_to_write");

	if ( sText == "" ) {
		FloatingTextStringOnCreature(
			"Setzt zuerst einen Text, den Ihr schreiben wollt;  indem ihr '/write Hier den Text' eingebt..",
			oPC,
			0);
		SetItemCharges(oPen, GetItemCharges(oPen) + 1);
		return;
	}

	if ( "c_paper" != GetTag(oPaper) ) {
		FloatingTextStringOnCreature("Ihr koennt nur auf Pergament schreiben.", oPC, 0);
		SetItemCharges(oPen, GetItemCharges(oPen) + 1);
		return;
	}


	FloatingTextStringOnCreature("Ihr rollt das Pergament auf ..", oPC, 0);

	if ( DoExplosiveRunes(oPaper, oPC) )
		return;

	if ( DoSepiaSnakeSigil(oPaper, oPC) )
		return;

	int nSigil = GetLocalInt(oPaper, "paper_sigil");
	int nSigilBroken = GetLocalInt(oPaper, "paper_sigil_broken");

	if ( !GetIsDM(oPC) ) {
		if ( nSigil && !nSigilBroken ) {
			Floaty(".. dabei brecht Ihr das Siegel ..", oPC, 0);
			SetLocalInt(oPaper, "paper_sigil_broken", 1);
		}
	}

	int nWriteCycle = GetLocalInt(oPaper, "paper_writecycles");
	int nTotalLength = GetTotalTextLength(oPaper);

	int
	nEstimate = GetStringLength(sText) + nTotalLength,
	nEstimateRemaining = nEstimate - PAPER_MAX_LENGTH;

	if ( nEstimate > PAPER_MAX_LENGTH ) {
		FloatingTextStringOnCreature("Soviel passt nicht mehr auf dieses Pergament.", oPC, 0);
		FloatingTextStringOnCreature("Ihr schaetzt, dass Ihr noch " +
			IntToString(nEstimateRemaining) + " Buchstaben unterbringt.", oPC, 0);
		SetItemCharges(oPen, GetItemCharges(oPen) + 1);
		return;
	}

	AddText(oPC, oPaper, sText);
	SetLocalString(oPC, "paper_text_to_write", "");

	FloatingTextStringOnCreature("Ihr schreibt Euren Text nun auf dieses Pergament.", oPC, 0);
	FixPergamentName(oPaper);
}


void AddText(object oWriter, object oPaper, string sText) {
	int nWriteCycle = GetLocalInt(oPaper, "paper_writecycles");

	SetLocalInt(oPaper, "paper_cid_" + IntToString(nWriteCycle), GetCharacterID(oWriter));
	SetLocalString(oPaper, "paper_text_" + IntToString(nWriteCycle), sText);
	SetLocalString(oPaper, "paper_name_" + IntToString(nWriteCycle), GetName(oWriter));

	nWriteCycle++;
	SetLocalInt(oPaper, "paper_writecycles", nWriteCycle);
}

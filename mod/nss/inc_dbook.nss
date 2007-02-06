// recipe dynamic books

#include "inc_lists"
#include "inc_cdb"
#include "inc_craft"

void DBook_MakeDialog(object oPC);



void DBook_Start(object oPC, object oBook) {
	DeleteLocalInt(oPC, "rcp_sel");
	SetLocalObject(oPC, "dbook_current", oBook);


	DBook_MakeDialog(oPC);
	AssignCommand(oPC, ActionStartConversation(oPC, "list_select", TRUE, TRUE));

}

void DBook_MakeDialog(object oPC) {
	ClearList(oPC, "rcp");

	object oBook = GetLocalObject(oPC, "dbook_current");

	int nCSkill = GetCraftSkillByTag(GetSubString(GetTag(oBook), 6, 1024)); // dbook_*
	if ( nCSkill == 0 )
		return;

	int iSelRecipe = GetLocalInt(oPC, "rcp_sel");

	int nCID = GetCharacterID(oPC);

	if ( !GetIsDM(oPC) && !nCID ) {
		SendMessageToPC(oPC, "Bug, nicht in DB gefunden.");
		return;
	}

	int nID = 0, nCount = 0;
	string sName, sDesc;
	string sRecipeText;

	// Show the menue
	if ( !iSelRecipe ) {
		DeleteLocalInt(oPC, "selected_recipe");

		if (/*CheckMask(oPC, AMASK_CRAFT_ADMIN)*/ GetIsDM(oPC) )
			SQLQuery("select `id`, `name` from `craft_prod` where `cskill` = " +
				IntToString(nCSkill) + " order by `name` asc;");
		else
			SQLQuery(
				"select `id`, `name` from `craft_prod` where `id` = (select `recipe` from `craft_rcpbook` where `craft_prod`.`id` = `craft_rcpbook`.`recipe` and `character` = "
				+ IntToString(nCID) +
				" and `cskill` = " + IntToString(nCSkill) + " limit 1) and active = 1 order by `name` asc;");

		while ( SQLFetch() ) {
			nID = StringToInt(SQLGetData(1));
			sName = SQLGetData(2);

			AddListItem(oPC, "rcp", sName);
			SetListInt(oPC, "rcp", nID);

			nCount += 1;
		}

		struct PlayerSkill psk = GetPlayerSkill(oPC, nCSkill);

		sRecipeText = "Ihr blaettert in Eurem Rezeptbuch.  " +
					  IntToString(nCount) +
					  " Rezepte sind darin enthalten.  Eure Faehigkeiten in diesem Handwerk belaufen sich auf "
					  +
					  IntToString(psk.practical) + " praktische Stufen, sowie " +
					  IntToString(psk.theory) + " theoretische Stufen.  Eure Erfahrungspunkte liegen bei " +
					  IntToString(psk.practical_xp) +
					  " XP - fuer einen Aufstieg sind noch " +
					  IntToString(GetNextCraftLevelXPCAP(psk.practical) - psk.practical_xp) + " XP noetig.";

		ResetConvList(oPC, oPC, "rcp", 50000, "dbook_cb", sRecipeText);

		// Show the specific recipe
	} else {

		nID = GetLocalInt(oPC, "selected_recipe");
		if ( !nID ) {
			nID = GetListInt(oPC, "rcp", GetLocalInt(oPC, "ConvList_Select"));
			SetLocalInt(oPC, "selected_recipe", nID);
		}

		/*SendMessageToPC(oPC, "iSelRecipe = " + IntToString(iSelRecipe));
		 * SendMessageToPC(oPC, "ConvListSelect = " + IntToString(GetLocalInt(oPC, "ConvList_Select")));
		 *
		 * nID = GetListInt(oPC, "rcp", iSelRecipe);
		 * SendMessageToPC(oPC, "nID with iSelRecipe = " + IntToString(nID));
		 *
		 * nID = GetListInt(oPC, "rcp", GetLocalInt(oPC, "ConvList_Select"));
		 * SendMessageToPC(oPC, "nID with ConvListSelect = " + IntToString(nID));*/


		ClearList(oPC, "rcp");

		SQLQuery(
			"select replace(`desc`,'\r\n','\n'),`cskill_min`,`cskill_max` from `craft_prod` where `id` = " +
			IntToString(nID) + " limit 1;");

		if ( !SQLFetch() ) {
			sRecipeText =
				"Rezept nicht gefunden!  Dies ist ein Datenbank-Fehler; bitte die Uhrzeit und was gerade getan wurde merken und das ganze dann einem SL melden.";
		} else {
			string
			sD = SQLGetData(1),
			sMin = SQLGetData(2),
			sMax = SQLGetData(3);
			sRecipeText = sD + "  Benoetigte Mindest-Faehigkeit in diesem Handwerk: " + sMin;

			AddListItem(oPC, "rcp", "Dieses Rezept als Arbeitsplan festlegen.");
			SetListInt(oPC, "rcp", 1);
		}

		ResetConvList(oPC, oPC, "rcp", 50000, "dbook_cb", sRecipeText, "", "", "dbook_backtomenu",
			"Zurueck zur Liste");
	}
}

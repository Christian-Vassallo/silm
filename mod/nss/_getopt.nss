#include "_mnx"
#include "_gen"



// Get options
int getopt(string str, string opts = "", object oPC = OBJECT_SELF);

// Resets all options.
int getoptreset(object oPC = OBJECT_SELF);

// Returns argument n
string arg(int n, object oPC = OBJECT_SELF);

// Returns the argument count
int argc(object oPC = OBJECT_SELF);

//xx
int opt(string n, object oPC = OBJECT_SELF);

//yy
string optv(string n, object oPC = OBJECT_SELF);

// Returns the complete, unparsed string, including all options.
string getoptargs(object oPC = OBJECT_SELF);

// Returns the complete, unparsed string, excluding all options.
string getoptarga(object oPC = OBJECT_SELF);


//



string getoptargs(object oPC = OBJECT_SELF) {
	struct mnxRet r = mnxCmd("getoptargs");

	if ( r.error ) {
		ToPC("There was an error processing your request: " + r.ret);
		return "";
	}

	return r.ret;
}

string getoptarga(object oPC = OBJECT_SELF) {
	struct mnxRet r = mnxCmd("getoptarga");

	if ( r.error ) {
		ToPC("There was an error processing your request: " + r.ret);
		return "";
	}

	return r.ret;
}


int getopt(string str, string opts = "", object oPC = OBJECT_SELF) {
	struct mnxRet r = mnxRun(oPC, "getopt", opts, str);

	if ( r.error )
		ToPC("There was an error processing your request: " + r.ret);

	//SetLocalInt(oPC, "go_iteration", GetLocalInt(oPC, "go_iteration") + 1);

	return !r.error;
}


int argc(object oPC = OBJECT_SELF) {
	// if (getoptvalid(oPC) && GetLocalInt(oPC, "go_argc"))
	//    return GetLocalInt(oPC, "go_argc");

	struct mnxRet r = mnxCmd("getoptc");
	if ( r.error ) {
		ToPC("There was an error processing your request: " + r.ret);
		return 0;
	}

	// SetLocalInt(oPC, "go_argc", StringToInt(r.ret));

	return StringToInt(r.ret);
}

string arg(int n, object oPC = OBJECT_SELF) {
	//if (getoptvalid(oPC) && "" != GetLocalString(oPC, "go_arg_" + IntToString(n)))
	//    return GetLocalString(oPC, "go_arg_" + IntToString(n));

	struct mnxRet r = mnxCmd("getopta", IntToString(n));

	if ( r.error ) {
		ToPC("There was an error processing your request: " + r.ret);
		return "";
	}

	//SetLocalString(oPC, "go_arg_" + IntToString(n), r.ret);

	return r.ret;
}


int opt(string n, object oPC = OBJECT_SELF) {
	//if (getoptvalid(oPC) && GetLocalInt(oPC, "go_opt_" + n))
	//    return GetLocalInt(oPC, "go_opt_" + n);

	struct mnxRet r = mnxCmd("getopti", n);

	if ( r.error ) {
		ToPC("There was an error processing your request: " + r.ret);
		return 0;
	}

	//SetLocalInt("go_opt_" + n, StringToInt(r.ret == 1));

	return StringToInt(r.ret) == 1;
}

string optv(string n, object oPC = OBJECT_SELF) {
	//if (getoptvalid(oPC) && "" != GetLocalString(oPC, "go_opt_" + n))
	//    return GetLocalString(oPC, "go_opt_" + n);


	struct mnxRet r = mnxCmd("getoptv", n);
	if ( r.error ) {
		ToPC("There was an error processing your request: " + r.ret);
		return "";
	}

	//SetLocalString(oPC, "go_opt_" + n, r.ret);

	return r.ret;
}



int getoptreset(object oPC = OBJECT_SELF) {
	// SetLocalInt(oPC, "go_iteration", 0);

	struct mnxRet r = mnxCmd("getoptreset");
	if ( r.error ) {
		ToPC("There was an error processing your request: " + r.ret);
		return 0;
	}


	return 1;
}





// Deprecated code below
// now uses the new option parser,
// optimised for speed.


/*
 *
 * /* TODO:
 * - Moan about unknown options
 *
 *
 * const string
 * 	GETOPT_ENDOPT = "--";
 *
 * // Parses sStr, setting local variables on
 * // oO.
 * // OPT_COUNT
 * //    count of passed options
 * // OPT_0 to _(COUNT-1)
 * //    options
 * // ARG_COUNT
 * //    count of passed arguments
 * // ARG_0 to count-1
 * //
 * // requiredOptions format ist "opt|opt2|opt3"
 * //
 * // Returns TRUE if the parsing succeeded,
 * // or FALSE if it failed (not all required arguments
 * // or options passed in)
 * int GetOpt(string sStr, int nRequiredArguments = 0, string sRequiredOptions = "", object oO = OBJECT_SELF);
 *
 * // Returns the whole argument string as passed to GetOpt(),
 * // with the options filtered out!
 * string GetWholeArgumentString(object oPC = OBJECT_SELF);
 *
 * void AddOpt(int iC, string sOpt, object oO) {
 * 	string sVal = "";
 * 	int i = FindSubString(sOpt, "=");
 * 	if (i != -1) {
 * 		sVal = GetSubString(sOpt, i + 1, GetStringLength(sOpt));
 * 		sOpt = GetSubString(sOpt, 0, i);
 * 	}
 *
 * 	SetLocalString(oO, "OPT_" + IntToString(iC), sOpt);
 * 	SetLocalString(oO, "OPTV_" + IntToString(iC), sVal);
 * 	SetLocalString(oO, "OPTVS_" + sOpt, sVal);
 * }
 *
 *
 * int GetOpt(string sStr, int nRequiredArguments = 0, string sRequiredOptions = "", object oO = OBJECT_SELF) {
 * 	int nOpt = 0,
 * 		nArg = 0;
 *
 * 	SetLocalInt(oO, "getopt", 1);
 *
 * 	sRequiredOptions += "|";
 *
 * 	string sCurrent = "", sC = "";
 *
 * 	int i = 0, inQuote = 0, isOpt = 0, escape = 0;
 *
 * 	string sAll = "";
 *
 * 	for (i = 0; i < GetStringLength(sStr); i++) {
 * 		sC = GetSubString(sStr, i, 1);
 *
 *
 *
 * 		// Start a new option
 * 		if (sC == "-" && sCurrent == "") {
 * 			isOpt = 1;
 * 			continue;
 * 		}
 *
 * 		if (!isOpt)
 * 			sAll += sC;
 *
 *
 * 		if (sC == "'") {
 * 			inQuote = !inQuote;
 * 			continue;
 * 		}
 *
 * 		if (sC == " " && !inQuote) {
 * 			// start new token
 *
 * 			if (sCurrent == "") {
 * 				// d("Empty argument/option, dropping.");
 * 				continue;
 * 			}
 *
 * 			if (1 == isOpt) {
 * 				AddOpt(nOpt, sCurrent, oO);
 * 				nOpt += 1;
 * 				isOpt = 0;
 * 			} else {
 * 				SetLocalString(oO, "ARG_" + IntToString(nArg), sCurrent);
 * 				nArg += 1;
 * 			}
 * 			sCurrent = "";
 *
 * 			continue;
 * 		}
 *
 * 		sCurrent += sC;
 * 	}
 *
 * 	if (sCurrent != "") {
 * 		if (1 == isOpt) {
 * 			AddOpt(nOpt, sCurrent, oO);
 * 			nOpt += 1;
 * 		} else {
 * 			SetLocalString(oO, "ARG_" + IntToString(nArg), sCurrent);
 * 			nArg += 1;
 * 		}
 * 	}
 *
 * 	SetLocalInt(oO, "OPT_COUNT", nOpt);
 * 	SetLocalInt(oO, "ARG_COUNT", nArg);
 * 	SetLocalString(oO, "ARG_ALL", sAll);
 *
 *
 * 	int bOptPassed = 1;
 * 	for (i = 0; i < nOpt; i++) {
 * 		if (FindSubString(sRequiredOptions, GetLocalString(oO, "OPT_" + IntToString(i)) + "|") == -1) {
 * 			bOptPassed = 0;
 * 			break;
 * 		}
 * 	}
 *
 * 	return (nArg >= nRequiredArguments && bOptPassed);
 * }
 *
 * int GetOptionCount(object oPC = OBJECT_SELF) {
 * 	if (GetLocalInt(oPC, "getopt") == 0)
 * 		return 0;
 * 	return GetLocalInt(oPC, "OPT_COUNT");
 * }
 *
 *
 * int GetArgumentCount(object oPC = OBJECT_SELF) {
 * 	if (GetLocalInt(oPC, "getopt") == 0)
 * 		return 0;
 * 	return GetLocalInt(oPC, "ARG_COUNT");
 * }
 *
 * string GetOption(int i, object oPC = OBJECT_SELF) {
 * 	if (GetLocalInt(oPC, "getopt") == 0)
 * 		return "";
 * 	if (i >= GetOptionCount())
 * 		return "";
 * 	return GetLocalString(oPC, "OPT_" + IntToString(i));
 * }
 *
 *
 * string GetOptionValueI(int i, object oPC = OBJECT_SELF) {
 * 	if (GetLocalInt(oPC, "getopt") == 0)
 * 		return "";
 * 	if (i >= GetOptionCount())
 * 		return "";
 * 	return GetLocalString(oPC, "OPTV_" + IntToString(i));
 * }
 *
 * string GetOptionValue(string s, object oPC = OBJECT_SELF) {
 * 	if (GetLocalInt(oPC, "getopt") == 0)
 * 		return "";
 * 	int i = 0;
 * 	for (i = 0; i < GetOptionCount(); i++)
 * 		if (GetOption(i) == s)
 * 			return GetOptionValueI(i);
 *
 * 	return "";
 * }
 *
 *
 * int HasOption(string s, object oPC = OBJECT_SELF) {
 * 	if (GetLocalInt(oPC, "getopt") == 0)
 * 		return 0;
 * 	int i = 0;
 * 	for (i = 0; i < GetOptionCount(); i++)
 * 		if (GetOption(i) == s)
 * 			return 1;
 * 	return 0;
 * }
 *
 *
 * int opt(string s, object oPC = OBJECT_SELF) {
 * 	return HasOption(s, oPC);
 * }
 *
 * string optv(string s, object oPC = OBJECT_SELF) {
 * 	return GetOptionValue(s, oPC);
 * }
 *
 *
 * string GetArgument(int i, object oPC = OBJECT_SELF) {
 * 	if (GetLocalInt(oPC, "getopt") == 0)
 * 		return "";
 * 	if (i >= GetArgumentCount())
 * 		return "";
 * 	return GetLocalString(oPC, "ARG_" + IntToString(i));
 * }
 *
 *
 *
 * string GetWholeArgumentString(object oPC = OBJECT_SELF) {
 * 	if (GetLocalInt(oPC, "getopt") == 0)
 * 		return "";
 * 	return GetLocalString(oPC, "ARG_ALL");
 * }
 *
 * void GetOptInvalidate(object oPC = OBJECT_SELF) {
 * 	SetLocalInt(oPC, "getopt", 0);
 * }            */

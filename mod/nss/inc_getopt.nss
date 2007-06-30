#include "inc_mnx"
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

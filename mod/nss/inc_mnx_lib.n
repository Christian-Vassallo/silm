/*
 * By Bernard 'Elven' Stoeckner <elven@elven.de>
 * Licence: None/Private
 */

#include "inc_mnx"

struct SystemTime {
	int year;
	int month;
	int hour;
	int day;
	int minute;
	int sec;
	int usec;
	string weekday;
};


// Splits a string by sRX, which is a
// posix-compatible regular expression without
// delimiters.
// Example:  mSplitRX("\s+", "this is    a text")
//  would return [this, is, a, text]
// Returns the number of results.
int mSplitRX(string sRX, string sText);


string mSplitResult(int nArg);


// Returns the current system uptime in seconds on
// the system RMNX is running on.
int mGetSystemUptime();

// Returns the current unixtime on the system
// RMNX is running on.
int mGetUnixtime();

// Returns the current system on the system
// time RMNX is running on.
struct SystemTime mGetSystemTime();

// Returns str encoded into base64
string mB64Encode(string str);

// Returns str decoded as base64
string mB64Decode(string str);

// Returns the MD5 hash of str
string mMD5(string str);

// Returns the SHA-1 hash of str
string mSHA1(string str);

// Returns str in camel case.
// Camel Case Looks Like This.
string mGetStringCamelCase(string str);

// Returns str with swapped case.
// Swapped Case -> sWAPPED cASE
string mGetStringSwapCase(string str);

// Returns str desreveR.
string mGetStringReverse(string str);

// Returns str where each occurence of regexp is replaced with replace.
// regexp is to be a POSIX-compatible regular expression.
string mGetStringGSub(string str, string regexp, string replace = "");

// Treats str as a hexadecimal value and returns the corresponding decimal value.
// Example: "0x12Af", "-564", "5", "-0x2"
int mHex(string str);

// Treats str as a octal value and returns the corresponding decimal value.
// Example: "123", "-123", "10"
int mOct(string str);

// Returns the successor of str.
// See the ruby documentation String#succ for further details.
// Example: "abcd" -> "abce", "test1" -> "test2", "1999zzz" -> "2000aaa", "***" -> "**+"
string mGetStringSucc(string str);

// Returns the crypt() value of str
string mGetStringCrypt(string str, string salt);


// Compares two strings.
// Returns
//   -1 if a < b
//    0 if a = b
//   +1 if a > b
int mStringCompare(string a, string b, int caseSensitive = TRUE);

/* Implementation */


int mCommandSplit(string sText, string sSplitAt = "&&") {
	struct mnxRet r = mnxCmd("commandsplit", sText, sSplitAt);
	if ( r.error )
		return 0;

	return StringToInt(r.ret);
}

string mCommandSplitGet(int n) {
	struct mnxRet r = mnxCmd("commandget", IntToString(n));
	if ( r.error )
		return "";

	return r.ret;
}


int mSplitRX(string sRX, string sText) {
	struct mnxRet r = mnxCmd("split", sRX, sText);
	if ( r.error )
		return 0;

	return StringToInt(r.ret);
}


string mSplitRXResult(int nArg) {
	struct mnxRet r = mnxCmd("splitarg", IntToString(nArg));
	if ( r.error )
		return "";

	return r.ret;
}


int mGetSystemUptime() {
	return StringToInt(mnxCommand("EXEC", "cat /proc/uptime | cut -d '.' -f 1"));
}


struct SystemTime mGetSystemTime() {
	string i = mnxCommand("SYSTEMTIME");
	//if (string
	//XXX: todo
	struct SystemTime r;
	return r;
}

int mGetUnixtime() {
	return StringToInt(mnxCommand("EXEC", "date +%s"));
}

string mB64Encode(string str) {
	return mnxCommand("B64ENC", str);
}

string mB64Decode(string str) {
	return mnxCommand("B64DEC", str);
}

string mMD5(string str) {
	return mnxCommand("MD5", str);
}

string mSHA1(string str) {
	return mnxCommand("SHA1", str);
}

string mGetStringCamelCase(string str) {
	return mnxCommand("STRCAMELCASE", str);
}

string mGetStringReversed(string str) {
	return mnxCommand("STRREVERSE", str);
}

string mGetStringGSub(string str, string regexp, string replace = "") {
	return mnxCommand("STRGSUB", str, regexp, replace);
}


string mGetStringSwapCase(string str) {
	return mnxCommand("STRSWAPCASE", str);
}

int mHex(string str) {
	return StringToInt(mnxCommand("STRHEX", str));
}

int mOct(string str) {
	return StringToInt(mnxCommand("STROCT", str));
}

string mGetStringSucc(string str) {
	return mnxCommand("STRSUCC", str);
}

string mGetStringCrypt(string str, string salt) {
	return mnxCommand("STRCRYPT", str, salt);
}

int mStringCompare(string a, string b, int caseSensitive = TRUE) {
	return StringToInt(mnxCommand("STRCOMPARE", a, b, caseSensitive == TRUE ? "1" : "0"));
}

const string
COL255 =
	" !#$%&'()*+,-./MIN123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~�����������������������������������������������������������������������������������������������������������������������";

const int
HI = 210,
MI = 128,
LO = 80,

MIN = 1,
MAX = 210;

struct Colour {
	int r;
	int g;
	int b;
};

struct Colour CS(int r, int g, int b);
struct Colour CSRand();

struct Colour Lighten(struct Colour c, int nAmount);
struct Colour Darken(struct Colour c, int nAmount);

// Returns sText rainbowified.
// Warning, long text and low step size will
// produce obscene amounts of traffic.
string RainbowText(string sText, int nStepSize = 2, int bCheatCloseTags = TRUE);

// Returns a colourised version of text.
string C(string text, struct Colour c);

string ColourTagClose();
string ColourTag(struct Colour c);

struct Colour GetLocalColour(object oPC, string sName);
void SetLocalColour(object oPC, string sName, struct Colour cC);

/* predefined colours */
struct Colour
cInvalid = CS(0, 0, 0),

cRed = CS(HI, MIN, MIN),
cMidRed = CS(MI, MIN, MIN),
cDarkRed = CS(LO, MIN, MIN),
cBlue = CS(MIN, MIN, HI),
cLightBlue = CS(MIN, MI, HI),
cDarkBlue = CS(MIN, MIN, LO),
cGreen = CS(MIN, HI, MIN),
cMidGreen = CS(MIN, MI, MIN),
cDarkGreen = CS(MIN, LO, MIN),
cYellow = CS(HI, HI, MIN),
cDarkYellow = CS(LO, LO, MIN),
cMagenta = CS(HI, MIN, HI),
cDarkMagenta = CS(LO, MIN, LO),
cTeal = CS(MIN, HI, HI),
cDarkTeal = CS(MIN, LO, LO),
cOrange = CS(HI, MI, MIN),
cLightGrey = CS(MI, MI, MI),
cDarkGrey = CS(LO, LO, LO),

cBlack = CS(MIN, MIN, MIN),
cWhite = CS(MAX, MAX, MAX);

/* implementation */


struct Colour GetLocalColour(object oPC, string sName) {
	struct Colour r;
	r.r = GetLocalInt(oPC, "c_" + sName + "_r");
	r.g = GetLocalInt(oPC, "c_" + sName + "_g");
	r.b = GetLocalInt(oPC, "c_" + sName + "_b");
	return r;
}

void SetLocalColour(object oPC, string sName, struct Colour cC) {
	SetLocalInt(oPC, "c_" + sName + "_r", cC.r);
	SetLocalInt(oPC, "c_" + sName + "_g", cC.g);
	SetLocalInt(oPC, "c_" + sName + "_b", cC.b);
}


string IntToChar(int i) {
	if ( i >= GetStringLength(COL255) )
		i = GetStringLength(COL255) - 1;
	return GetSubString(COL255, i, 1);
}


string C(string text, struct Colour c) {
	return ColourTag(c) + text + ColourTagClose();
}

string ColourTag(struct Colour c) {
	return "<c" + IntToChar(c.r) + IntToChar(c.g) + IntToChar(c.b) + ">";
}

string ColourTagClose() {
	return "</c>";
}

struct Colour CS(int r, int g, int b) {
	struct Colour c;
	c.r = r; c.g = g; c.b = b;
	if ( c.r > MAX ) c.r = MAX;
	if ( c.g > MAX ) c.g = MAX;
	if ( c.b > MAX ) c.b = MAX;
	if ( c.r < MIN ) c.r = MIN;
	if ( c.g < MIN ) c.g = MIN;
	if ( c.b < MIN ) c.b = MIN;
	return c;
}

struct Colour CSRand() {
	struct Colour c;
	c.r = MIN + Random(MAX - MIN);
	c.g = MIN + Random(MAX - MIN);
	c.b = MIN + Random(MAX - MIN);
	return c;
}

struct Colour Lighten(struct Colour c, int nAmount) {
	struct Colour r;
	r.r = c.r + nAmount;
	r.g = c.g + nAmount;
	r.b = c.b + nAmount;
	if ( r.r > MAX ) r.r = MAX;
	if ( r.g > MAX ) r.g = MAX;
	if ( r.b > MAX ) r.b = MAX;
	if ( r.r < MIN ) r.r = MIN;
	if ( r.g < MIN ) r.g = MIN;
	if ( r.b < MIN ) r.b = MIN;
	return r;
}

struct Colour Darken(struct Colour c, int nAmount) {
	struct Colour r;
	r.r = c.r - nAmount;
	r.g = c.g - nAmount;
	r.b = c.b - nAmount;
	if ( r.r > MAX ) r.r = MAX;
	if ( r.g > MAX ) r.g = MAX;
	if ( r.b > MAX ) r.b = MAX;
	if ( r.r < MIN ) r.r = MIN;
	if ( r.g < MIN ) r.g = MIN;
	if ( r.b < MIN ) r.b = MIN;
	return r;
}



string RainbowText(string sText, int nStepSize = 2, int bCheatCloseTags = TRUE) {
	int nEachLetter = GetStringLength(sText) / nStepSize;

	string sOut = "", sMed = "";
	struct Colour c;

	int i = 0;

	for ( i = 0; i < nEachLetter; i += nEachLetter ) {
		sMed = GetSubString(sText, i, nEachLetter);

		// ColourStep(c, 1024, nEachLetter);

		sOut += ColourTag(c) + sMed;
		if ( !bCheatCloseTags )
			sOut += ColourTagClose();
	}
	return sOut;
}

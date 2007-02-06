const string
COL255 =
	" !#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~€‚ƒ„…†‡ˆ‰Š‹Œ‘’“”•–—˜™š›œŸ¡¢£¤¥§¨©ª«¬­®¯°±²³´µ¶·¸¸º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖ×ØÙÚÛÜİŞßàáâãäåæçèéêëìíîïñòóôõö÷øùúûüış";

const int
HI = 210,
MI = 128,
LO = 80,

MIN = 0,
MAX = 210;

struct Colour {
	int r;
	int g;
	int b;
};

struct Colour CS(int r, int g, int b);

struct Colour Lighten(struct Colour c, int nAmount);
struct Colour Darken(struct Colour c, int nAmount);


// Returns a colourised version of text.
string C(string text, struct Colour c);

string ColourTagClose(struct Colour c);
string ColourTag(struct Colour c);

/* predefined colours */
struct Colour
cRed = CS(HI, 0, 0),
cDarkRed = CS(LO, 0, 0),
cBlue = CS(0, 0, HI),
cLightBlue = CS(0, MI, HI),
cDarkBlue = CS(0, 0, LO),
cGreen = CS(0, HI, 0),
cDarkGreen = CS(0, LO, 0),
cYellow = CS(HI, HI, 0),
cDarkYellow = CS(LO, LO, 0),
cMagenta = CS(HI, 0, HI),
cDarkMagenta = CS(LO, 0, LO),
cTeal = CS(0, HI, HI),
cDarkTeal = CS(0, LO, LO),
cOrange = CS(HI, MI, 0);

/* implementation */

string IntToChar(int i) {
	return GetSubString(COL255, i, 1);
}


string C(string text, struct Colour c) {
	return ColourTag(c) + text + ColourTagClose(c);
}

string ColourTag(struct Colour c) {
	return "<c" + IntToChar(c.r) + IntToChar(c.g) + IntToChar(c.b) + ">";
}

string ColourTagClose(struct Colour c) {
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

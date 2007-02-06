const string
sTranslate = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜäöü";

string ConvertDrow(string sLetter) {
	if ( GetStringLength(sLetter) > 1 )
		sLetter = GetStringLeft(sLetter, 1);
	int iTrans = FindSubString(sTranslate, sLetter);

	switch ( iTrans ) {
		case 0:
			return "il";

		case 26:
			return "Il";

		case 1:
			return "f";

		case 2:
			return "st";

		case 28:
			return "St";

		case 3:
			return "X";

		case 4:
			return "ss";

		case 5:
			return "o";

		case 6:
			return "v";

		case 7:
			return "ir";

		case 33:
			return "Ir";

		case 8:
			return "e";

		case 9:
			return "vi";

		case 35:
			return "Vi";

		case 10:
			return "go";

		case 11:
			return "c";

		case 12:
			return "li";

		case 13:
			return "l";

		case 14:
			return "e";

		case 15:
			return "ty";

		case 41:
			return "Ty";

		case 16:
			return "r";

		case 17:
			return "m";

		case 18:
			return "la";

		case 44:
			return "La";

		case 19:
			return "an";

		case 45:
			return "As";

		case 20:
			return "y";

		case 21:
			return "el";

		case 47:
			return "El";

		case 22:
			return "ky";

		case 48:
			return "Ky";

		case 23:
			return "'";

		case 24:
			return "z";

		case 25:
			return "p'";

		case 27:
			return "F";

		case 29:
			return "X";

		case 30:
			return "A";

		case 31:
			return "O";

		case 32:
			return "V";

		case 34:
			return "E";

		case 36:
			return "Go";

		case 37:
			return "C";

		case 38:
			return "Li";

		case 39:
			return "L";

		case 40:
			return "E";

		case 42:
			return "R";

		case 43:
			return "M";

		case 46:
			return "Y";

		case 49:
			return "'";

		case 50:
			return "s";

		case 51:
			return "P'";

		default:
			return sLetter;
	}

	return "";
}

string Drow(string sPhrase) {
	/*return CryptoHomophonicSubstitution(sPhrase,
	 * 	"abcdefghijklmnopqrstuvwxyz",
	 * 	"il|f|st|w|ss|o|v|ir|e|vi|go|c|li|l|e|ty|r|m|la|an|y|el|ky|'|a|p",
	 * 	"|",
	 * 	CRYPTO_BEHAVIOUR_EXTRACHAR_KEEP & CRYPTO_BEHAVIOUR_CASEMAP & CRYPTO_BEHAVIOUR_CASEIGNORE);
	 * Too many instructions = nwscript stack limitations. Cant be worked around. */

	string sOutput;
	int i = 0;
	for ( i = 0; i < GetStringLength(sPhrase); i++ ) {
		sOutput += ConvertDrow(GetSubString(sPhrase, i, 1));
	}
	return sOutput;
}



string ConvertInfernal(string sLetter) {
	if ( GetStringLength(sLetter) > 1 )
		sLetter = GetStringLeft(sLetter, 1);
	int iTrans = FindSubString(sTranslate, sLetter);

	switch ( iTrans ) {
		case 0:
			return "o";

		case 1:
			return "c";

		case 2:
			return "r";

		case 3:
			return "j";

		case 4:
			return "a";

		case 5:
			return "v";

		case 6:
			return "k";

		case 7:
			return "r";

		case 8:
			return "y";

		case 9:
			return "z";

		case 10:
			return "g";

		case 11:
			return "m";

		case 12:
			return "z";

		case 13:
			return "r";

		case 14:
			return "y";

		case 15:
			return "k";

		case 16:
			return "r";

		case 17:
			return "n";

		case 18:
			return "k";

		case 19:
			return "d";

		case 20:
			return "'";

		case 21:
			return "r";

		case 22:
			return "'";

		case 23:
			return "k";

		case 24:
			return "i";

		case 25:
			return "g";

		case 26:
			return "O";

		case 27:
			return "C";

		case 28:
			return "R";

		case 29:
			return "J";

		case 30:
			return "A";

		case 31:
			return "V";

		case 32:
			return "K";

		case 33:
			return "R";

		case 34:
			return "Y";

		case 35:
			return "Z";

		case 36:
			return "G";

		case 37:
			return "M";

		case 38:
			return "Z";

		case 39:
			return "R";

		case 40:
			return "Y";

		case 41:
			return "K";

		case 42:
			return "R";

		case 43:
			return "N";

		case 44:
			return "K";

		case 45:
			return "D";

		case 46:
			return "'";

		case 47:
			return "R";

		case 48:
			return "'";

		case 49:
			return "K";

		case 50:
			return "I";

		case 51:
			return "G";

		default:
			return sLetter;
	}

	return "";
} //end ConvertInfernal

string Infernal(string sPhrase) {
	string sOutput;
	int i = 0;
	for ( i = 0; i < GetStringLength(sPhrase); i++ ) {
		sOutput += ConvertInfernal(GetSubString(sPhrase, i, 1));
	}
	return sOutput;
}

string ConvertAbyssal(string sLetter) {
	if ( GetStringLength(sLetter) > 1 )
		sLetter = GetStringLeft(sLetter, 1);
	int iTrans = FindSubString(sTranslate, sLetter);

	switch ( iTrans ) {
		case 27:
			return "N";

		case 28:
			return "M";

		case 29:
			return "G";

		case 30:
			return "A";

		case 31:
			return "K";

		case 32:
			return "S";

		case 33:
			return "D";

		case 35:
			return "H";

		case 36:
			return "B";

		case 37:
			return "L";

		case 38:
			return "P";

		case 39:
			return "T";

		case 40:
			return "E";

		case 41:
			return "B";

		case 43:
			return "N";

		case 44:
			return "M";

		case 45:
			return "G";

		case 48:
			return "B";

		case 51:
			return "T";

		case 0:
			return "oo";

		case 26:
			return "OO";

		case 1:
			return "n";

		case 2:
			return "m";

		case 3:
			return "g";

		case 4:
			return "a";

		case 5:
			return "k";

		case 6:
			return "s";

		case 7:
			return "d";

		case 8:
			return "oo";

		case 34:
			return "OO";

		case 9:
			return "h";

		case 10:
			return "b";

		case 11:
			return "l";

		case 12:
			return "p";

		case 13:
			return "t";

		case 14:
			return "e";

		case 15:
			return "b";

		case 16:
			return "ch";

		case 42:
			return "Ch";

		case 17:
			return "n";

		case 18:
			return "m";

		case 19:
			return "g";

		case 20:
			return "ae";

		case 46:
			return "Ae";

		case 21:
			return "ts";

		case 47:
			return "Ts";

		case 22:
			return "b";

		case 23:
			return "bb";

		case 49:
			return "Bb";

		case 24:
			return "ee";

		case 50:
			return "Ee";

		case 25:
			return "t";

		default:
			return sLetter;
	}

	return "";
} //end ConvertAbyssal

string Abyssal(string sPhrase) {
	string sOutput;
	int i = 0;
	for ( i = 0; i < GetStringLength(sPhrase); i++ ) {
		sOutput += ConvertAbyssal(GetSubString(sPhrase, i, 1));
	}
	return sOutput;
}

string ConvertCelestial(string sLetter) {
	if ( GetStringLength(sLetter) > 1 )
		sLetter = GetStringLeft(sLetter, 1);
	int iTrans = FindSubString(sTranslate, sLetter);

	switch ( iTrans ) {
		case 0:
			return "a";

		case 1:
			return "p";

		case 2:
			return "v";

		case 3:
			return "t";

		case 4:
			return "el";

		case 5:
			return "b";

		case 6:
			return "w";

		case 7:
			return "r";

		case 8:
			return "i";

		case 9:
			return "m";

		case 10:
			return "x";

		case 11:
			return "h";

		case 12:
			return "s";

		case 13:
			return "c";

		case 14:
			return "u";

		case 15:
			return "q";

		case 16:
			return "d";

		case 17:
			return "n";

		case 18:
			return "l";

		case 19:
			return "y";

		case 20:
			return "o";

		case 21:
			return "j";

		case 22:
			return "f";

		case 23:
			return "g";

		case 24:
			return "z";

		case 25:
			return "k";

		case 26:
			return "A";

		case 27:
			return "P";

		case 28:
			return "V";

		case 29:
			return "T";

		case 30:
			return "El";

		case 31:
			return "B";

		case 32:
			return "W";

		case 33:
			return "R";

		case 34:
			return "I";

		case 35:
			return "M";

		case 36:
			return "X";

		case 37:
			return "H";

		case 38:
			return "S";

		case 39:
			return "C";

		case 40:
			return "U";

		case 41:
			return "Q";

		case 42:
			return "D";

		case 43:
			return "N";

		case 44:
			return "L";

		case 45:
			return "Y";

		case 46:
			return "O";

		case 47:
			return "J";

		case 48:
			return "F";

		case 49:
			return "G";

		case 50:
			return "Z";

		case 51:
			return "K";

		default:
			return sLetter;
	}

	return "";
} //end ConvertCelestial

string Celestial(string sPhrase) {
	string sOutput;
	int i = 0;
	for ( i = 0; i < GetStringLength(sPhrase); i++ ) {
		sOutput += ConvertCelestial(GetSubString(sPhrase, i, 1));
	}
	return sOutput;
}

string ConvertGoblin(string sLetter) {
	if ( GetStringLength(sLetter) > 1 )
		sLetter = GetStringLeft(sLetter, 1);
	int iTrans = FindSubString(sTranslate, sLetter);

	switch ( iTrans ) {
		case 0:
			return "u";

		case 1:
			return "p";

		case 2:
			return "";

		case 3:
			return "t";

		case 4:
			return "'";

		case 5:
			return "v";

		case 6:
			return "k";

		case 7:
			return "r";

		case 8:
			return "o";

		case 9:
			return "z";

		case 10:
			return "g";

		case 11:
			return "m";

		case 12:
			return "s";

		case 13:
			return "";

		case 14:
			return "u";

		case 15:
			return "b";

		case 16:
			return "";

		case 17:
			return "n";

		case 18:
			return "k";

		case 19:
			return "d";

		case 20:
			return "u";

		case 21:
			return "";

		case 22:
			return "'";

		case 23:
			return "";

		case 24:
			return "o";

		case 25:
			return "w";

		case 26:
			return "U";

		case 27:
			return "P";

		case 28:
			return "";

		case 29:
			return "T";

		case 30:
			return "'";

		case 31:
			return "V";

		case 32:
			return "K";

		case 33:
			return "R";

		case 34:
			return "O";

		case 35:
			return "Z";

		case 36:
			return "G";

		case 37:
			return "M";

		case 38:
			return "S";

		case 39:
			return "";

		case 40:
			return "U";

		case 41:
			return "B";

		case 42:
			return "";

		case 43:
			return "N";

		case 44:
			return "K";

		case 45:
			return "D";

		case 46:
			return "U";

		case 47:
			return "";

		case 48:
			return "'";

		case 49:
			return "";

		case 50:
			return "O";

		case 51:
			return "W";

		default:
			return sLetter;
	}

	return "";
} //end ConvertGoblin

string Goblin(string sPhrase) {
	string sOutput;
	int i = 0;
	for ( i = 0; i < GetStringLength(sPhrase); i++ ) {
		sOutput += ConvertGoblin(GetSubString(sPhrase, i, 1));
	}
	return sOutput;
}

string ConvertDraconic(string sLetter) {
	if ( GetStringLength(sLetter) > 1 )
		sLetter = GetStringLeft(sLetter, 1);
	int iTrans = FindSubString(sTranslate, sLetter);

	switch ( iTrans ) {
		case 0:
			return "e";

		case 26:
			return "E";

		case 1:
			return "po";

		case 27:
			return "Po";

		case 2:
			return "st";

		case 28:
			return "St";

		case 3:
			return "ty";

		case 29:
			return "Ty";

		case 4:
			return "i";

		case 5:
			return "w";

		case 6:
			return "k";

		case 7:
			return "ni";

		case 33:
			return "Ni";

		case 8:
			return "un";

		case 34:
			return "Un";

		case 9:
			return "vi";

		case 35:
			return "Vi";

		case 10:
			return "go";

		case 36:
			return "Go";

		case 11:
			return "ch";

		case 37:
			return "Ch";

		case 12:
			return "li";

		case 38:
			return "Li";

		case 13:
			return "ra";

		case 39:
			return "Ra";

		case 14:
			return "y";

		case 15:
			return "ba";

		case 41:
			return "Ba";

		case 16:
			return "x";

		case 17:
			return "hu";

		case 43:
			return "Hu";

		case 18:
			return "my";

		case 44:
			return "My";

		case 19:
			return "dr";

		case 45:
			return "Dr";

		case 20:
			return "on";

		case 46:
			return "On";

		case 21:
			return "fi";

		case 47:
			return "Fi";

		case 22:
			return "zi";

		case 48:
			return "Zi";

		case 23:
			return "qu";

		case 49:
			return "Qu";

		case 24:
			return "an";

		case 50:
			return "An";

		case 25:
			return "ji";

		case 51:
			return "Ji";

		case 30:
			return "I";

		case 31:
			return "W";

		case 32:
			return "K";

		case 40:
			return "Y";

		case 42:
			return "X";

		default:
			return sLetter;
	}

	return "";
} //end ConvertDraconic

string Draconic(string sPhrase) {
	string sOutput;
	int i = 0;
	for ( i = 0; i < GetStringLength(sPhrase); i++ ) {
		sOutput += ConvertDraconic(GetSubString(sPhrase, i, 1));
	}
	return sOutput;
}

string ConvertDwarf(string sLetter) {
	if ( GetStringLength(sLetter) > 1 )
		sLetter = GetStringLeft(sLetter, 1);
	int iTrans = FindSubString(sTranslate, sLetter);

	switch ( iTrans ) {
		case 0:
			return "az";

		case 26:
			return "Az";

		case 1:
			return "po";

		case 27:
			return "Po";

		case 2:
			return "zi";

		case 28:
			return "Zi";

		case 3:
			return "t";

		case 4:
			return "a";

		case 5:
			return "wa";

		case 31:
			return "Wa";

		case 6:
			return "k";

		case 7:
			return "'";

		case 8:
			return "a";

		case 9:
			return "dr";

		case 35:
			return "Dr";

		case 10:
			return "g";

		case 11:
			return "n";

		case 12:
			return "l";

		case 13:
			return "r";

		case 14:
			return "ur";

		case 40:
			return "Ur";

		case 15:
			return "rh";

		case 41:
			return "Rh";

		case 16:
			return "k";

		case 17:
			return "h";

		case 18:
			return "th";

		case 44:
			return "Th";

		case 19:
			return "k";

		case 20:
			return "'";

		case 21:
			return "g";

		case 22:
			return "zh";

		case 48:
			return "Zh";

		case 23:
			return "q";

		case 24:
			return "o";

		case 25:
			return "j";

		case 29:
			return "T";

		case 30:
			return "A";

		case 32:
			return "K";

		case 33:
			return "'";

		case 34:
			return "A";

		case 36:
			return "G";

		case 37:
			return "N";

		case 38:
			return "L";

		case 39:
			return "R";

		case 42:
			return "K";

		case 43:
			return "H";

		case 45:
			return "K";

		case 46:
			return "'";

		case 47:
			return "G";

		case 49:
			return "Q";

		case 50:
			return "O";

		case 51:
			return "J";

		default:
			return sLetter;
	}

	return "";
} //end ConvertDwarf

string Dwarf(string sPhrase) {
	string sOutput;
	int i = 0;
	for ( i = 0; i < GetStringLength(sPhrase); i++ ) {
		sOutput += ConvertDwarf(GetSubString(sPhrase, i, 1));
	}
	return sOutput;
}

string ConvertElven(string sLetter) {
	if ( GetStringLength(sLetter) > 1 )
		sLetter = GetStringLeft(sLetter, 1);
	int iTrans = FindSubString(sTranslate, sLetter);

	switch ( iTrans ) {
		case 0:
			return "il";

		case 26:
			return "Il";

		case 1:
			return "f";

		case 2:
			return "ny";

		case 28:
			return "Ny";

		case 3:
			return "w";

		case 4:
			return "a";

		case 5:
			return "o";

		case 6:
			return "v";

		case 7:
			return "ir";

		case 33:
			return "Ir";

		case 8:
			return "e";

		case 9:
			return "qu";

		case 35:
			return "Qu";

		case 10:
			return "n";

		case 11:
			return "c";

		case 12:
			return "s";

		case 13:
			return "l";

		case 14:
			return "e";

		case 15:
			return "ty";

		case 41:
			return "Ty";

		case 16:
			return "h";

		case 17:
			return "m";

		case 18:
			return "la";

		case 44:
			return "La";

		case 19:
			return "an";

		case 45:
			return "An";

		case 20:
			return "y";

		case 21:
			return "el";

		case 47:
			return "El";

		case 22:
			return "am";

		case 48:
			return "Am";

		case 23:
			return "'";

		case 24:
			return "a";

		case 25:
			return "j";

		case 27:
			return "F";

		case 29:
			return "W";

		case 30:
			return "A";

		case 31:
			return "O";

		case 32:
			return "V";

		case 34:
			return "E";

		case 36:
			return "N";

		case 37:
			return "C";

		case 38:
			return "S";

		case 39:
			return "L";

		case 40:
			return "E";

		case 42:
			return "H";

		case 43:
			return "M";

		case 46:
			return "Y";

		case 49:
			return "'";

		case 50:
			return "A";

		case 51:
			return "J";

		default:
			return sLetter;
	}

	return "";
}

string Elven(string sPhrase) {
	string sOutput;
	int i = 0;
	for ( i = 0; i < GetStringLength(sPhrase); i++ ) {
		sOutput += ConvertElven(GetSubString(sPhrase, i, 1));
	}
	return sOutput;
}

string ConvertGnome(string sLetter) {
	if ( GetStringLength(sLetter) > 1 )
		sLetter = GetStringLeft(sLetter, 1);
	int iTrans = FindSubString(sTranslate, sLetter);

	switch ( iTrans ) {
		//cipher based on English -> Al Baed
		case 0:
			return "y";

		case 1:
			return "p";

		case 2:
			return "l";

		case 3:
			return "t";

		case 4:
			return "a";

		case 5:
			return "v";

		case 6:
			return "k";

		case 7:
			return "r";

		case 8:
			return "e";

		case 9:
			return "z";

		case 10:
			return "g";

		case 11:
			return "m";

		case 12:
			return "s";

		case 13:
			return "h";

		case 14:
			return "u";

		case 15:
			return "b";

		case 16:
			return "x";

		case 17:
			return "n";

		case 18:
			return "c";

		case 19:
			return "d";

		case 20:
			return "i";

		case 21:
			return "j";

		case 22:
			return "f";

		case 23:
			return "q";

		case 24:
			return "o";

		case 25:
			return "w";

		case 26:
			return "Y";

		case 27:
			return "P";

		case 28:
			return "L";

		case 29:
			return "T";

		case 30:
			return "A";

		case 31:
			return "V";

		case 32:
			return "K";

		case 33:
			return "R";

		case 34:
			return "E";

		case 35:
			return "Z";

		case 36:
			return "G";

		case 37:
			return "M";

		case 38:
			return "S";

		case 39:
			return "H";

		case 40:
			return "U";

		case 41:
			return "B";

		case 42:
			return "X";

		case 43:
			return "N";

		case 44:
			return "C";

		case 45:
			return "D";

		case 46:
			return "I";

		case 47:
			return "J";

		case 48:
			return "F";

		case 49:
			return "Q";

		case 50:
			return "O";

		case 51:
			return "W";

		default:
			return sLetter;
	}

	return "";
}

string Gnome(string sPhrase) {
	string sOutput;
	int i = 0;
	for ( i = 0; i < GetStringLength(sPhrase); i++ ) {
		sOutput += ConvertGnome(GetSubString(sPhrase, i, 1));
	}
	return sOutput;

	return sOutput;
}

string ConvertHalfling(string sLetter) {
	if ( GetStringLength(sLetter) > 1 )
		sLetter = GetStringLeft(sLetter, 1);
	int iTrans = FindSubString(sTranslate, sLetter);

	switch ( iTrans ) {
		//cipher based on Al Baed -> English
		case 0:
			return "e";

		case 1:
			return "p";

		case 2:
			return "s";

		case 3:
			return "t";

		case 4:
			return "i";

		case 5:
			return "w";

		case 6:
			return "k";

		case 7:
			return "n";

		case 8:
			return "u";

		case 9:
			return "v";

		case 10:
			return "g";

		case 11:
			return "c";

		case 12:
			return "l";

		case 13:
			return "r";

		case 14:
			return "y";

		case 15:
			return "b";

		case 16:
			return "x";

		case 17:
			return "h";

		case 18:
			return "m";

		case 19:
			return "d";

		case 20:
			return "o";

		case 21:
			return "f";

		case 22:
			return "z";

		case 23:
			return "q";

		case 24:
			return "a";

		case 25:
			return "j";

		case 26:
			return "E";

		case 27:
			return "P";

		case 28:
			return "S";

		case 29:
			return "T";

		case 30:
			return "I";

		case 31:
			return "W";

		case 32:
			return "K";

		case 33:
			return "N";

		case 34:
			return "U";

		case 35:
			return "V";

		case 36:
			return "G";

		case 37:
			return "C";

		case 38:
			return "L";

		case 39:
			return "R";

		case 40:
			return "Y";

		case 41:
			return "B";

		case 42:
			return "X";

		case 43:
			return "H";

		case 44:
			return "M";

		case 45:
			return "D";

		case 46:
			return "O";

		case 47:
			return "F";

		case 48:
			return "Z";

		case 49:
			return "Q";

		case 50:
			return "A";

		case 51:
			return "J";

		default:
			return sLetter;
	}

	return "";
}

string Halfling(string sPhrase) {
	string sOutput;
	int i = 0;
	for ( i = 0; i < GetStringLength(sPhrase); i++ ) {
		sOutput += ConvertHalfling(GetSubString(sPhrase, i, 1));
	}
	return sOutput;
}

string ConvertOrc(string sLetter) {
	if ( GetStringLength(sLetter) > 1 )
		sLetter = GetStringLeft(sLetter, 1);
	int iTrans = FindSubString(sTranslate, sLetter);

	switch ( iTrans ) {
		case 0:
			return "ha";

		case 26:
			return "Ha";

		case 1:
			return "p";

		case 2:
			return "z";

		case 3:
			return "t";

		case 4:
			return "o";

		case 5:
			return "";

		case 6:
			return "k";

		case 7:
			return "r";

		case 8:
			return "a";

		case 9:
			return "m";

		case 10:
			return "g";

		case 11:
			return "h";

		case 12:
			return "r";

		case 13:
			return "k";

		case 14:
			return "u";

		case 15:
			return "b";

		case 16:
			return "k";

		case 17:
			return "h";

		case 18:
			return "g";

		case 19:
			return "n";

		case 20:
			return "";

		case 21:
			return "g";

		case 22:
			return "r";

		case 23:
			return "r";

		case 24:
			return "'";

		case 25:
			return "m";

		case 27:
			return "P";

		case 28:
			return "Z";

		case 29:
			return "T";

		case 30:
			return "O";

		case 31:
			return "";

		case 32:
			return "K";

		case 33:
			return "R";

		case 34:
			return "A";

		case 35:
			return "M";

		case 36:
			return "G";

		case 37:
			return "H";

		case 38:
			return "R";

		case 39:
			return "K";

		case 40:
			return "U";

		case 41:
			return "B";

		case 42:
			return "K";

		case 43:
			return "H";

		case 44:
			return "G";

		case 45:
			return "N";

		case 46:
			return "";

		case 47:
			return "G";

		case 48:
			return "R";

		case 49:
			return "R";

		case 50:
			return "'";

		case 51:
			return "M";

		default:
			return sLetter;
	}

	return "";
}

string Orc(string sPhrase) {
	string sOutput;
	int i = 0;
	for ( i = 0; i < GetStringLength(sPhrase); i++ ) {
		sOutput += ConvertOrc(GetSubString(sPhrase, i, 1));
	}
	return sOutput;
}

string ConvertSylvan(string sLetter) {
	if ( GetStringLength(sLetter) > 1 ) sLetter = GetStringLeft(sLetter, 1);
	int iTrans = FindSubString(sTranslate, sLetter);
	switch ( iTrans ) {
		case 0: return "s";

		case 1: return "F";

		case 2: return "y";

		case 3: return "E";

		case 4: return "l";

		case 5: return "Y";

		case 6: return "v";

		case 7: return "Tr";

		case 8: return "a";

		case 9: return "Ee";

		case 10: return "n";

		case 11: return "Ny";

		case 12: return "mp";

		case 13: return "h";

		case 14: return "M";

		case 15: return "jo";

		case 16: return "li";

		case 17: return "nar";

		case 18: return "shr";

		case 19: return "ub";

		case 20: return "Whi";

		case 21: return "his";

		case 22: return "ssp";

		case 23: return "pey";

		case 24: return "tee";

		case 25: return "hee";

		case 26: return "na";

		case 27: return "At";

		case 28: return "Tu";

		case 29: return "Ure";

		case 30: return "aN";

		case 31: return "wh'";

		case 32: return "sy'";

		case 33: return "'l'v";

		case 34: return "-";

		case 35: return "Sy";

		case 36: return "'s";

		case 37: return "yu";

		case 38: return "el";

		case 39: return "Si'";

		case 40: return "lv";

		case 41: return "ll'";

		case 42: return "ve";

		case 43: return "ee";

		case 44: return "E";

		case 45: return "en";

		case 46: return "S";

		case 47: return "Y";

		case 48: return "Wy";

		case 49: return "Yv";

		case 50: return "Ki";

		case 51: return "tT";

		default: return sLetter;
	}

	return "";
}


string ConvertUnknown(string sLetter) {
	string sTranslate2 = "xzXZsS";
	return GetSubString(sTranslate2, Random(GetStringLength(sTranslate2)), 1);
}

string Unknown(string sPhrase) {
	string sOutput;
	int i = 0;
	for ( i = 0; i < GetStringLength(sPhrase); i++ ) {
		sOutput += ConvertUnknown(GetSubString(sPhrase, i, 1));
	}
	return sOutput;
}

string Sylvan(string sPhrase) {
	string sOutput;
	int i = 0;
	for ( i = 0; i < GetStringLength(sPhrase); i++ ) {
		sOutput += ConvertSylvan(GetSubString(sPhrase, i, 1));
	}
	return sOutput;
}


string Cant(string sLetter) {
	if ( GetStringLength(sLetter) > 1 )
		sLetter = GetStringLeft(sLetter, 1);

	if ( sLetter == "a" || sLetter == "A" )
		return "*shields eyes*";

	if ( sLetter == "b" || sLetter == "B" )
		return "*blusters*";

	if ( sLetter == "c" || sLetter == "C" )
		return "*coughs*";

	if ( sLetter == "d" || sLetter == "D" )
		return "*furrows brow*";

	if ( sLetter == "e" || sLetter == "E" )
		return "*examines ground*";

	if ( sLetter == "f" || sLetter == "F" )
		return "*frowns*";

	if ( sLetter == "g" || sLetter == "G" )
		return "*glances up*";

	if ( sLetter == "h" || sLetter == "H" )
		return "*looks thoughtful*";

	if ( sLetter == "i" || sLetter == "I" )
		return "*looks bored*";

	if ( sLetter == "j" || sLetter == "J" )
		return "*rubs chin*";

	if ( sLetter == "k" || sLetter == "K" )
		return "*scratches ear*";

	if ( sLetter == "l" || sLetter == "L" )
		return "*looks around*";

	if ( sLetter == "m" || sLetter == "M" )
		return "*mmm hmm*";

	if ( sLetter == "n" || sLetter == "N" )
		return "*nods*";

	if ( sLetter == "o" || sLetter == "O" )
		return "*grins*";

	if ( sLetter == "p" || sLetter == "P" )
		return "*smiles*";

	if ( sLetter == "q" || sLetter == "Q" )
		return "*shivers*";

	if ( sLetter == "r" || sLetter == "R" )
		return "*rolls eyes*";

	if ( sLetter == "s" || sLetter == "S" )
		return "*scratches nose*";

	if ( sLetter == "t" || sLetter == "T" )
		return "*turns a bit*";

	if ( sLetter == "u" || sLetter == "U" )
		return "*glances idly*";

	if ( sLetter == "v" || sLetter == "V" )
		return "*runs hand through hair*";

	if ( sLetter == "w" || sLetter == "W" )
		return "*waves*";

	if ( sLetter == "x" || sLetter == "X" )
		return "*stretches*";

	if ( sLetter == "y" || sLetter == "Y" )
		return "*yawns*";

	if ( sLetter == "z" || sLetter == "Z" )
		return "*shrugs*";

	return "*nods*";
}


string ConvertDruid(string sLetter) {
	if ( GetStringLength(sLetter) > 1 ) sLetter = GetStringLeft(sLetter, 1);
	int iTrans = FindSubString(sTranslate, sLetter);
	switch ( iTrans ) {
		case 0: return "d";

		case 1: return "d";

		case 2: return "r";

		case 3: return "o";

		case 4: return "u";

		case 5: return "o";

		case 6: return "i";

		case 7: return "l";

		case 8: return "d";

		case 9: return "i";

		case 10: return "i";

		case 11: return "t";

		case 12: return "c";

		case 13: return "t";

		case 14: return "t";

		case 15: return "l";

		case 16: return "a";

		case 17: return "e";

		case 18: return "l";

		case 19: return "d";

		case 20: return "k";

		case 21: return "o";

		case 22: return "Wii";

		case 23: return "C";

		case 24: return "U";

		case 25: return "T";

		case 26: return "G";

		case 27: return "O";

		case 28: return "N";

		case 29: return "R";

		case 30: return "T";

		case 31: return "K";

		case 32: return "N";

		case 33: return "L";

		case 34: return "E";

		case 35: return "A";

		case 36: return "S";

		case 37: return "T";

		case 38: return "O";

		case 39: return "C";

		case 40: return "H";

		case 41: return "I";

		case 42: return "O";

		case 43: return "D";

		case 44: return "A";

		case 45: return "I";

		case 46: return "T";

		case 47: return "U";

		case 48: return "B";

		case 49: return "R";

		case 50: return "U";

		case 51: return "D";

		default: return sLetter;
	}

	return "";
}



string Druid(string sPhrase) {
	string sOutput;
	int i = 0;
	for ( i = 0; i < GetStringLength(sPhrase); i++ ) {
		sOutput += ConvertDruid(GetSubString(sPhrase, i, 1));
	}
	return sOutput;
}

string ConvertGiant(string sLetter) {
	if ( GetStringLength(sLetter) > 1 ) sLetter = GetStringLeft(sLetter, 1);
	int iTrans = FindSubString(sTranslate, sLetter);
	switch ( iTrans ) {
		case 0: return "Ugh";

		case 1: return "Gk";

		case 2: return "K";

		case 3: return "gj";

		case 4: return "j";

		case 5: return "r";

		case 6: return "t";

		case 7: return "u";

		case 8: return "i";

		case 9: return "s";

		case 10: return "S";

		case 11: return "a";

		case 12: return "V";

		case 13: return "G";

		case 14: return "H";

		case 15: return "X";

		case 16: return "R";

		case 17: return "We";

		case 18: return "Rt";

		case 19: return "Jk";

		case 20: return "Jk";

		case 21: return "jk";

		case 22: return "kj";

		case 23: return "ty";

		case 24: return "tr";

		case 25: return "lp";

		case 26: return "plop";

		case 27: return "qrk";

		case 28: return "cd";

		case 29: return "dg";

		case 30: return "fhg";

		case 31: return "hgf";

		case 32: return "gty";

		case 33: return "rk";

		case 34: return "er";

		case 35: return "gh";

		case 36: return "kj";

		case 37: return "r";

		case 38: return "t";

		case 39: return "s";

		case 40: return "v";

		case 41: return "s";

		case 42: return "a";

		case 43: return "h";

		case 44: return "t";

		case 45: return "k";

		case 46: return "y";

		case 47: return "h";

		case 48: return "u";

		case 49: return "i";

		case 50: return "j";

		case 51: return "w";

		default: return sLetter;
	}

	return "";
}

string Giant(string sPhrase) {
	string sOutput;
	int i = 0;
	for ( i = 0; i < GetStringLength(sPhrase); i++ ) {
		sOutput += ConvertGiant(GetSubString(sPhrase, i, 1));
	}
	return sOutput;
}


string ConvertGnoll(string sLetter) {
	if ( GetStringLength(sLetter) > 1 ) sLetter = GetStringLeft(sLetter, 1);
	int iTrans = FindSubString(sTranslate, sLetter);

	switch ( iTrans ) {
		case 0: return "Gr";

		case 1: return "gr";

		case 2: return "ra";

		case 3: return "wr";

		case 4: return "aw";

		case 5: return "Wr";

		case 6: return "rA";

		case 7: return "Ra";

		case 8: return "gR";

		case 9: return "yip";

		case 10: return "yi";

		case 11: return "Ip";

		case 12: return "ep";

		case 13: return "Ee";

		case 14: return "eE";

		case 15: return "Ep";

		case 16: return "yw";

		case 17: return "ra";

		case 18: return "wa";

		case 19: return "yee";

		case 20: return "ngh";

		case 21: return "u";

		case 22: return "gn";

		case 23: return "ol";

		case 24: return "l";

		case 25: return "en";

		case 26: return "gh";

		case 27: return "yee";

		case 28: return "ey";

		case 29: return "eh";

		case 30: return "pf";

		case 31: return "ph";

		case 32: return "er";

		case 33: return "kip";

		case 34: return "kI";

		case 35: return "Ip";

		case 36: return "Ye";

		case 37: return "En";

		case 38: return "Gh";

		case 39: return "uU";

		case 40: return "yw";

		case 41: return "y";

		case 42: return "o";

		case 43: return "n";

		case 44: return "d";

		case 45: return "a";

		case 46: return "l";

		case 47: return "l";

		case 48: return "arf";

		case 49: return "a";

		case 50: return "r";

		case 51: return "f";

		default: return sLetter;
	}

	return "";
}

string Gnoll(string sPhrase) {
	string sOutput;
	int i = 0;
	for ( i = 0; i < GetStringLength(sPhrase); i++ ) {
		sOutput += ConvertGnoll(GetSubString(sPhrase, i, 1));
	}
	return sOutput;
}


string ConvertIgnan(string sLetter) {
	if ( GetStringLength(sLetter) > 1 ) sLetter = GetStringLeft(sLetter, 1);
	int iTrans = FindSubString(sTranslate, sLetter);
	switch ( iTrans ) {
		case 0: return "k";

		case 1: return "ra";

		case 2: return "kk";

		case 3: return "le";

		case 4: return "kr";

		case 5: return "ck";

		case 6: return "k k";

		case 7: return "-";

		case 8: return "sk";

		case 9: return "k";

		case 10: return "ig";

		case 11: return "g";

		case 12: return "na";

		case 13: return "hh";

		case 14: return "k";

		case 15: return "n";

		case 16: return "hu";

		case 17: return "kc";

		case 18: return "kr";

		case 19: return "cr";

		case 20: return "rc";

		case 21: return "k";

		case 22: return "rk";

		case 23: return "ckl";

		case 24: return "zk";

		case 25: return "";

		case 26: return "hhh";

		case 27: return "kz";

		case 28: return "k";

		case 29: return "kk";

		case 30: return "h-";

		case 31: return "ha";

		case 32: return " k";

		case 33: return "te";

		case 34: return "'k";

		case 35: return "la";

		case 36: return "r'";

		case 37: return "ng";

		case 38: return "'";

		case 39: return "mr";

		case 40: return "ak";

		case 41: return "ua";

		case 42: return "i";

		case 43: return "ge";

		case 44: return "f";

		case 45: return "'r";

		case 46: return "ss";

		case 47: return "er";

		case 48: return "re";

		case 49: return "r";

		case 50: return "fi";

		case 51: return "e";

		default: return sLetter;
	}

	return "";
}

string Ignan(string sPhrase) {
	string sOutput;
	int i = 0;
	for ( i = 0; i < GetStringLength(sPhrase); i++ ) {
		sOutput += ConvertIgnan(GetSubString(sPhrase, i, 1));
	}
	return sOutput;
}


string ConvertAuran(string sLetter) {
	if ( GetStringLength(sLetter) > 1 ) sLetter = GetStringLeft(sLetter, 1);
	int iTrans = FindSubString(sTranslate, sLetter);
	switch ( iTrans ) {
		case 0: return "Wh";

		case 26: return "Wys";

		case 1: return "Yss";

		case 2: return "S";

		case 3: return "Y";

		case 4: return "W";

		case 5: return "o";

		case 6: return "C";

		case 7: return "u";

		case 8: return "S";

		case 9: return "Ss";

		case 10: return "Oo";

		case 11: return "io";

		case 12: return "i";

		case 13: return "f";

		case 14: return "ph";

		case 15: return "pys";

		case 16: return "sys";

		case 17: return "se";

		case 18: return "eu";

		case 19: return "u";

		case 20: return "J";

		case 21: return "A";

		case 22: return "Ae";

		case 23: return ".O";

		case 24: return "e. A";

		case 25: return "Ab";

		case 27: return "b";

		case 28: return "Y";

		case 29: return "we";

		case 30: return "ye";

		case 31: return "se";

		case 32: return "sy";

		case 33: return "s";

		case 34: return "Y";

		case 35: return "U";

		case 36: return "I";

		case 37: return "O";

		case 38: return "W";

		case 39: return "e";

		case 40: return "wY";

		case 41: return "cA";

		case 42: return "ac";

		case 43: return "jh";

		case 44: return "ah";

		case 45: return "ha";

		case 46: return "v";

		case 47: return "th";

		case 48: return "gh";

		case 49: return "vy";

		case 50: return "uy";

		case 51: return "el";

		default: return sLetter;
	}

	return "";
}

string Auran(string sPhrase) {
	string sOutput;
	int i = 0;
	for ( i = 0; i < GetStringLength(sPhrase); i++ ) {
		sOutput += ConvertAuran(GetSubString(sPhrase, i, 1));
	}
	return sOutput;
}

string ConvertAquan(string sLetter) {
	if ( GetStringLength(sLetter) > 1 ) sLetter = GetStringLeft(sLetter, 1);
	int iTrans = FindSubString(sTranslate, sLetter);
	switch ( iTrans ) {
		case 0: return "ha";

		case 26: return "Ha";

		case 1: return "p";

		case 2: return "z";

		case 3: return "j";

		case 4: return "o";

		case 5: return "";

		case 6: return "c";

		case 7: return "r";

		case 8: return "a";

		case 9: return "m";

		case 10: return "s";

		case 11: return "h";

		case 12: return "r";

		case 13: return "k";

		case 14: return "u";

		case 15: return "b";

		case 16: return "d";

		case 17: return "h";

		case 18: return "y";

		case 19: return "n";

		case 20: return "";

		case 21: return "i";

		case 22: return "r";

		case 23: return "r";

		case 24: return "'";

		case 25: return "m";

		case 27: return "Ph";

		case 28: return "Z";

		case 29: return "Th";

		case 30: return "O";

		case 31: return "";

		case 32: return "Ff";

		case 33: return "Rrs";

		case 34: return "A";

		case 35: return "M";

		case 36: return "Gh";

		case 37: return "H";

		case 38: return "R";

		case 39: return "S";

		case 40: return "U";

		case 41: return "B";

		case 42: return "Cs";

		case 43: return "Ha";

		case 44: return "Se";

		case 45: return "Ne";

		case 46: return "";

		case 47: return "G";

		case 48: return "R";

		case 49: return "R";

		case 50: return "'";

		case 51: return "N";

		default: return sLetter;
	}

	return "";
}

string Aquan(string sPhrase) {
	string sOutput;
	int i = 0;
	for ( i = 0; i < GetStringLength(sPhrase); i++ ) {
		sOutput += ConvertAquan(GetSubString(sPhrase, i, 1));
	}
	return sOutput;
}

string ConvertTerran(string sLetter) {
	if ( GetStringLength(sLetter) > 1 ) sLetter = GetStringLeft(sLetter, 1);
	int iTrans = FindSubString(sTranslate, sLetter);
	switch ( iTrans ) {
		case 0: return "R";

		case 1: return "T";

		case 2: return "E";

		case 3: return "T";

		case 4: return "C";

		case 5: return "ter";

		case 6: return "O";

		case 7: return "A";

		case 8: return "l";

		case 9: return "rra";

		case 10: return "oO";

		case 11: return "R";

		case 12: return "E";

		case 13: return "C";

		case 14: return "for";

		case 15: return "d";

		case 16: return "T";

		case 17: return "Rr";

		case 18: return "D";

		case 19: return "h";

		case 20: return "K";

		case 21: return "mi";

		case 22: return "D";

		case 23: return "S";

		case 24: return "A";

		case 25: return "ng";

		case 26: return "t";

		case 27: return "wa";

		case 28: return "rf";

		case 29: return "wa";

		case 30: return "N";

		case 31: return "o";

		case 32: return "rph";

		case 33: return "cO";

		case 34: return "n";

		case 35: return "Nc";

		case 36: return "r";

		case 37: return "ete";

		case 38: return "di";

		case 39: return "e";

		case 40: return "rT";

		case 41: return "mu";

		case 42: return "d";

		case 43: return "s";

		case 44: return "Mn";

		case 45: return "in";

		case 46: return "ni";

		case 47: return "ng";

		case 48: return "i'";

		case 49: return "Kr";

		case 50: return "Umb";

		case 51: return "Le";

		default: return sLetter;
	}

	return "";
}

string Terran(string sPhrase) {
	string sOutput;
	int i = 0;
	for ( i = 0; i < GetStringLength(sPhrase); i++ ) {
		sOutput += ConvertTerran(GetSubString(sPhrase, i, 1));
	}
	return sOutput;
}


string ConvertChondathan(string sLetter) {
	if ( GetStringLength(sLetter) > 1 ) sLetter = GetStringLeft(sLetter, 1);
	int iTrans = FindSubString(sTranslate, sLetter);
	switch ( iTrans ) {
		case 0: return "eh";

		case 1: return "bee";

		case 2: return "sea";

		case 3: return "de";

		case 4: return "e";

		case 5: return "eph";

		case 6: return "gee";

		case 7: return "ehtch";

		case 8: return "eye";

		case 9: return "jae";

		case 10: return "kay";

		case 11: return "ell";

		case 12: return "emm";

		case 13: return "en";

		case 14: return "oh";

		case 15: return "pee";

		case 16: return "kue";

		case 17: return "arr";

		case 18: return "es";

		case 19: return "tea";

		case 20: return "you";

		case 21: return "vea";

		case 22: return "uu";

		case 23: return "why";

		case 24: return "ex";

		case 25: return "zee";

		case 26: return "Eh";

		case 27: return "Bee";

		case 28: return "Sea";

		case 29: return "De";

		case 30: return "E";

		case 31: return "Eph";

		case 32: return "Gee";

		case 33: return "Ehtch";

		case 34: return "Eye";

		case 35: return "Jae";

		case 36: return "Kay";

		case 37: return "Ell";

		case 38: return "Emm";

		case 39: return "En";

		case 40: return "Oh";

		case 41: return "Pee";

		case 42: return "Kue";

		case 43: return "Arr";

		case 44: return "Es";

		case 45: return "Tea";

		case 46: return "You";

		case 47: return "Vea";

		case 48: return "Uu";

		case 49: return "Why";

		case 50: return "Ex";

		case 51: return "Zee";

		default: return sLetter;
	}

	return "";
}




string Chondathan(string sPhrase) {
	string sOutput;
	int i = 0;
	for ( i = 0; i < GetStringLength(sPhrase); i++ ) {
		sOutput += ConvertChondathan(GetSubString(sPhrase, i, 1));
	}
	return sOutput;
}


string ConvertUndercommon(string sLetter) {
	if ( GetStringLength(sLetter) > 1 )
		sLetter = GetStringLeft(sLetter, 1);
	int iTrans = FindSubString(sTranslate, sLetter);

	switch ( iTrans ) {
		case 0: return "u";

		case 1: return "h";

		case 2: return "s";

		case 3: return "w";

		case 4: return "o";

		case 5: return "a";

		case 6: return "b";

		case 7: return "t";

		case 8: return "e";

		case 9: return "kk";

		case 10: return "n";

		case 11: return "c";

		case 12: return "z";

		case 13: return "l";

		case 14: return "i";

		case 15: return "d";

		case 16: return "f";

		case 17: return "m";

		case 18: return "r";

		case 19: return "n";

		case 20: return "y";

		case 21: return "x";

		case 22: return "bb";

		case 23: return "dr";

		case 24: return "gi";

		case 25: return "jh";

		case 26: return "U";

		case 27: return "H";

		case 28: return "S";

		case 29: return "W";

		case 30: return "O";

		case 31: return "A";

		case 32: return "B";

		case 33: return "T";

		case 34: return "E";

		case 35: return "KK";

		case 36: return "N";

		case 37: return "C";

		case 38: return "Z";

		case 39: return "L";

		case 40: return "I";

		case 41: return "D";

		case 42: return "F";

		case 43: return "M";

		case 44: return "R";

		case 45: return "N";

		case 46: return "Y";

		case 47: return "X";

		case 48: return "BB";

		case 49: return "Dr";

		case 50: return "Gi";

		case 51: return "Jh";

		default: return sLetter;
	}

	return "";
}



string Undercommon(string sPhrase) {
	string sOutput;
	int i = 0;
	for ( i = 0; i < GetStringLength(sPhrase); i++ ) {
		sOutput += ConvertUndercommon(GetSubString(sPhrase, i, 1));
	}
	return sOutput;
}


string ConvertIlluskan(string sLetter) {
	if ( GetStringLength(sLetter) > 1 ) sLetter = GetStringLeft(sLetter, 1);
	int iTrans = FindSubString(sTranslate, sLetter);
	switch ( iTrans ) {
		case 0: return "n";

		case 1: return "nr";

		case 2: return "a";

		case 3: return "r";

		case 4: return "k";

		case 5: return "a";

		case 6: return "s";

		case 7: return "t";

		case 8: return "u";

		case 9: return "n";

		case 10: return "l";

		case 11: return "i";

		case 12: return "l";

		case 13: return "m";

		case 14: return "i";

		case 15: return " ";

		case 16: return "mo";

		case 17: return "e";

		case 18: return "o";

		case 19: return "m";

		case 20: return "n";

		case 21: return "o";

		case 22: return "s";

		case 23: return "S";

		case 24: return "H";

		case 25: return "A";

		case 26: return "A";

		case 27: return "V";

		case 28: return "E";

		case 29: return "A";

		case 30: return "S";

		case 31: return "G";

		case 32: return "E";

		case 33: return "R";

		case 34: return "N";

		case 35: return "U";

		case 36: return "O";

		case 37: return "A";

		case 38: return "R";

		case 39: return "T";

		case 40: return "T";

		case 41: return "H";

		case 42: return "H";

		case 43: return "Y";

		case 44: return "'U";

		case 45: return "M";

		case 46: return "T";

		case 47: return "-G";

		case 48: return "H";

		case 49: return "R";

		case 50: return "Gy";

		case 51: return " a";

		default: return sLetter;
	}

	return "";
}


string Illuskan(string sPhrase) {
	string sOutput;
	int i = 0;
	for ( i = 0; i < GetStringLength(sPhrase); i++ ) {
		sOutput += ConvertIlluskan(GetSubString(sPhrase, i, 1));
	}
	return sOutput;
}


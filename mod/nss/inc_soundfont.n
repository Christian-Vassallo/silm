const string
S_A = "Aph",
S_B = "Bat",
S_C = "Coh",
S_D = "Mah",
S_E = "Shi",
S_F = "Foh",
S_1 = "Nah",
S_2 = "Zor",
S_3 = "Fie",
S_4 = "Pen",
S_5 = "Lon",
S_6 = "Tif",
S_7 = "Jen",
S_8 = "Wel",
S_9 = "Gho",
S_0 = "Rhe";


string ObjectToSF(object oO);
string HexToSF(string sHexStr);


string HexToSF(string sHexStr) {
	string sRet = "";
	string sC;
	int i = 0;
	for ( i = 0; i < GetStringLength(sHexStr); i++ ) {
		sC = GetStringLowerCase(GetSubString(sHexStr, i, 1));
		if ( "a" == sC )
			sRet += S_A;
		if ( "b" == sC )
			sRet += S_B;
		if ( "c" == sC )
			sRet += S_C;
		if ( "d" == sC )
			sRet += S_D;
		if ( "e" == sC )
			sRet += S_E;
		if ( "f" == sC )
			sRet += S_F;

		if ( "0" == sC )
			sRet += S_0;
		if ( "1" == sC )
			sRet += S_1;
		if ( "2" == sC )
			sRet += S_2;
		if ( "3" == sC )
			sRet += S_3;
		if ( "4" == sC )
			sRet += S_4;
		if ( "5" == sC )
			sRet += S_5;
		if ( "6" == sC )
			sRet += S_6;
		if ( "7" == sC )
			sRet += S_7;
		if ( "8" == sC )
			sRet += S_8;
		if ( "9" == sC )
			sRet += S_9;

		if ( i < GetStringLength(sHexStr) - 1 )
			sRet += " ";
	}
	return sRet;
}


string ObjectToSF(object oO) {
	return HexToSF(GetStringRight(ObjectToString(oO), 6));
}

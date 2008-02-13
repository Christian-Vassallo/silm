
#define strlen(str) GetStringLength(str)

#define substr(str,start,len) GetSubString(str,start,len)

#define strpos(str,find) FindSubString(str,find)

#define strlwr(s) GetStringLowerCase(s)

#define strupper(s) GetStringUpperCase(s)

// Returns true if the given character is a numeric.
#define numeric_char(c) ("0" == c || "1" == c || "2" == c || "3" == c || \
"4" == c || "5" == c || "6" == c || "7" == c || "8" == c || "9" == c)

// Loops through string s, assigning the current character to the variable named v.
#define streach(s,v,code) __EBLOCK(\
string v; int iv = 0; while (iv < strlen(s)) {\
	v = strpos(s, iv); iv++; \
	code; \
})

// Splits the given string s split at regular expression delim, assigning to v.
#define streach_rx(str,delim,flags,v,code) __EBLOCK(\
	string v; string pcursor = pDeclare("select regexp_split_to_table(str, delim, flags);");\
	while (pCursorFetch(pcursor)) {\
		v = pGetStr(1);\
		code;\
	}\
	pCursorClose(pcursor); \
)

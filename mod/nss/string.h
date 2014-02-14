#ifndef STRING_H
#define STRING_H
// Macro: strlen(str)
#define strlen(str) GetStringLength(str)

// Macro: substr(str,start,len)
#define substr(str,start,len) GetSubString(str,start,len)

// Macro: strpos(str,find)
#define strpos(str,find) FindSubString(str,find)

// Macro: strlwr(s)
#define strlwr(s) GetStringLowerCase(s)

// Macro: strupper(s)
#define strupper(s) GetStringUpperCase(s)

// Macro: numeric_char(c)
// Returns true if the given character is a numeric.
#define numeric_char(c) ("0" == c || "1" == c || "2" == c || "3" == c || \
"4" == c || "5" == c || "6" == c || "7" == c || "8" == c || "9" == c)

// Macro: streach(s,v,code)
// Loops through string *s*, assigning the current character to the named variable *v*,
// running *code* for each iteration.
#define streach(s,v,code) __EBLOCK(\
string v; int iv = 0; while (iv < strlen(s)) {\
	v = strpos(s, iv); iv++; \
	code; \
})

// Macro: streach_rx(str,delim,flags,v,code)
// Splits the given string *str* split at regular expression *delim*, assigning it to
// the named variable *v*, and runs *code* for each iteration.
// Uses the database.
// Warning: requires a running transaction
#define streach_rx(str,delim,flags,v,code) __EBLOCK(\
	string v; string pcursor = pDeclare("select regexp_split_to_table('" + str + "','" + delim + "','" + flags + "');");\
	while (pCursorFetch(pcursor)) {\
		v = pGetStr(1);\
		code;\
	}\
	pCursorClose(pcursor); \
)

#endif

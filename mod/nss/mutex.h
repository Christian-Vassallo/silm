#ifndef MUTEX_H
#define MUTEX_H

// Macro: __mutex(obj,count,name,code)
// Creates a local named muted on obj** and runs *code* *count* times.
#define __mutex(obj,count,name,code) \
if (GetLocalInt(obj,"mtx_" + name) > count) { \
	SetLocalInt(obj,"mtx_" + name,GetLocalInt(obj,"mtx_" + name)+1);\
	code \
	SetLocalInt(obj,"mtx_" + name,GetLocalInt(obj,"mtx_" + name)-1);\
}

// Macro: __mutex_single(obj,name,code)
// Creates a single-run delayed named mutex
// Shorthand for __mutex(obj, 1, name, code)
#define __mutex_single(obj,name,code) __mutex(obj,1,name,code)

// Macro: __mutex_transaction(obj,partner,name,code)
// Creates a mutually exclusive transaction with a *parter* object
#define __mutex_transaction(obj,partner,name,code) \
if (GetLocalInt(obj,"mtxt_" + name) > 0) { \
	SetLocalInt(obj,"mtxt_" + name,0); \
} else { \
	SetLocalInt(partner,"mtxt_" + name,1); \
	code; \
}

// Macro: __nthcond(n,code)
// Run *code* only each *n*th evaluation for equalling tokens
#define __nthcond(n,token,code) __EBLOCK(\
string nthname = "__nth_" + __FILE__ + "_" + itoa(__LINE__) + "_" + token; \
if (GetLocalInt(GetModule(), nthname) >= n) { \
	SetLocalInt(GetModule(), nthname, 0); \
	code; \
} else { \
	SetLocalInt(GetModule(), nthname, GetLocalInt(GetModule(), nthname) + 1); \
}\
)

// Macro: __nth(n,code)
// Run *code* only each *n*th evaluation
#define __nth(n,code) __nthcond(n, "default", code)

#endif

#ifndef MUTEX_H
#define MUTEX_H


#define __mutex(obj,count,name,code) \
if (GetLocalInt(obj,"mtx_" + name) > count) { \
	SetLocalInt(obj,"mtx_" + name,GetLocalInt(obj,"mtx_" + name)+1);\
	code \
	SetLocalInt(obj,"mtx_" + name,GetLocalInt(obj,"mtx_" + name)-1);\
}

#define __mutex_single(obj,name,code) __mutex(obj,1,name,code)

#define __mutex_transaction(obj,partner,name,code) \
if (GetLocalInt(obj,"mtxt_" + name) > 0) { \
	SetLocalInt(obj,"mtxt_" + name,0); \
} else { \
	SetLocalInt(partner,"mtxt_" + name,1); \
	code; \
}



#endif

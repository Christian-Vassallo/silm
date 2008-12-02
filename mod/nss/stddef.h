#ifndef STDDEF_H
#define STDDEF_H

#define true TRUE
#define false FALSE

#define bool int

#define xstr(s) str(s)
#define str(s) #s

#define __LINE #line
#define __FILE #file

// Macro: __EBLOCK(code)
// Localized block-wrapper
#define __EBLOCK(x) do { x } while(0)

#define local(x) __EBLOCK(x)

#define queue(obj,diff,action) AssignCommand(obj,DelayCommand(diff,action))

#include "log.h"
#include "inline.h"
#include "iterators.h"
#include "mutex.h"
#include "string.h"
#include "effects.h"
#include "hook.h"
#include "core.h"

#endif

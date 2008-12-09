#ifndef INLINE_H
#define INLINE_H

#define MODULE GetModule()

#define MINUTES_PER_HOUR FloatToInt(HoursToSeconds(1)/60)
#define GetMinutesPerHour() MINUTES_PER_HOUR

// Macro: GetPCName(o)
// Returns the player name of o, even if o is in the process of logging out
#define GetPCName(o) (GetPCPlayerName(o)==""?GetLocalString(o,"player_name"):GetPCPlayerName(o))

// Macro: StringToBool(s)
// Converts strings to an appropriate boolean value.
#define StringToBool(s) (s=="true"||s=="yes"||s=="y"||s=="t"||StringToInt(s)!=0)

// Macro: BoolToString(b)
// Converts boolean values to a string.
#define BoolToString(b)	(b>0?"true":"false")

// Macro: exch(x,y)
// Swaps x and y of type int
#define exch(x,y) __EBLOCK(int tmp; tmp=x; x=y; y=tmp;)

// Macro: txch(t,x,y)
// Swaps x and y of typeclass t
#define xch(t,x,y) __EBLOCK(t tmp; tmp=x; x=y; y=tmp;)

// Macro: clamp(n,min,max)
// Clamps numeric value n between min and max
#define clamp(n,min,max) (n > max ? max : ( n < min ? min : n ))

// Macro: unsigned(i)
// Converts int i to an unsigned variant.
#define unsigned(i) i<0?0:i

#endif

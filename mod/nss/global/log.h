/* print debug messages if debugging is enabled for that specific section. */
#define _DEBUG(section,level,message) __EBLOCK(\
	if (level <= gvGetInt(section + "_debug")){ \
		string msg = __FILE__ + ":" + xstr(__LINE__) + "(" + section + "): " + message;\
		WriteTimestampedLogEntry(msg);\
		SendMessageToAllDMs(msg);\
	}\
)

/* print informational messages. disabled by default. */
#define _INFO(x)

/* advise the backend about something */
#define _ADVISE(x) "slowpath_XXX fix me"


/* print a non-fatal warning message */
#define _WARN(x)

/* print a error message */
#define _ERROR(x) __EBLOCK(\
	string msg = __FILE__ + ":" + xstr(__LINE__) + ": " + x;\
	WriteTimestampedLogEntry(msg);\
	SendMessageToAllDMs(msg);\
)

/* write an absolutely fatal error to the logfile. */
#define _FATAL(message) \
WriteTimestampedLogEntry("FATAL " + __FILE__ + ":" + xstr(__LINE__) + ": " + message);\


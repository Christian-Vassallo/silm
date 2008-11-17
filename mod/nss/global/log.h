// Macro: _DEBUG(section,level,message)
// print debug messages if debugging is enabled for that specific section
#define _DEBUG(section,level,message) __EBLOCK(\
	if (level <= gvGetInt(section + "_debug")){ \
		string inline_message = "Debug: "+ __FILE__ + ":" + xstr(__LINE__) + "(" + section + "): " + message;\
		WriteTimestampedLogEntry(inline_message);\
		SendMessageToAllDMs(inline_message);\
	}\
)

// Macro: _INFO(x)
// print informational messages.
#define _INFO(message) __EBLOCK(\
	string inline_message = "Info: " + __FILE__ + ":" + xstr(__LINE__) + ": " + message;\
	WriteTimestampedLogEntry(inline_message);\
	SendMessageToAllDMs(inline_message);\
)

// Macro: _ADVISE(x)
// advise the backend about something
#define _ADVISE(x) "slowpath_XXX fix me"

// Macro: _WARN(message)
// print a non-fatal warning message
#define _WARN(message) __EBLOCK(\
	string inline_message = "Warning: " + __FILE__ + ":" + xstr(__LINE__) + ": " + message;\
	WriteTimestampedLogEntry(inline_message);\
	SendMessageToAllDMs(inline_message);\
)

// Macro: _ERROR(message)
// print a error message
#define _ERROR(message) __EBLOCK(\
	string inline_message = "ERROR: " + __FILE__ + ":" + xstr(__LINE__) + ": " + message;\
	WriteTimestampedLogEntry(inline_message);\
	SendMessageToAllDMs(inline_message);\
)

// Macro: _FATAL(message)
// write an absolutely fatal error to the logfile
#define _FATAL(message) \
WriteTimestampedLogEntry("FATAL: " + __FILE__ + ":" + xstr(__LINE__) + ": " + message);

#define _NOTIMPL() _FATAL("not implemented")

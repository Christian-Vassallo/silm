/* Note: nwns int overflows at 1 << 31, so 1 << 30 is the highest usable bitmask */

/*
Section: Events

	Each event constant has zero or more of the following modifiers  Const: 
	- defer - Event always runs deferred (scripts registered for sync execution will *NOT RUN*), always implies *no abort*
	- sync - Event always runs synchronously (scripts registered for deferred execution will be forced to run sync)
	- stop - Event can be stopped by returning EVENT_RESULT_STOP, if the script is running sync
	- suppress - Event can be suppressed by returning EVENT_RESULT_SUPPRESS, if the script is running sync
	- runnable: object - what object the event will run on
	- actor: object - what object the actor will be
	- actedon: object - what object the actedon will be
	- actedat: location - what location actedat will be

	sync, abort, defer:
	- Event scripts can be run either in *sync* or in *defer* mode.
	- sync mode has the advantage of allowing event cancellation, but *will block* (and possibly run against TMI).
	- defer mode will be queued for execution after the current script, and *order of events is not guaranteed*.
	Also, event-specific native functions that return event-related data are *not guaranteed to be consistent*.
	Do NOT use them, use the provided objects (actor, actedon, actedat) by the event system instead. If you
	require any other event-related information, use sync mode.
	- If possible, choose defer mode for performance and stability.
	- Some events are forced to run in sync mode for technical reasons.
	- Some events are forced to run in defer mode (since there would be no advantage running them in sync mode, or the overhead would be too great).

Section: Script Return Codes
return codes for event scripts. You can return these through SetEventScriptReturnValue()
in an event script to indicate certain conditions.

	Const: EVENT_RESULT_FAIL
		Event script failed to execute. Indicate this to handle error conditions.

	Const: EVENT_RESULT_END
		Request termination of other after this one. Only works reliably when in sync mode.

	Const: EVENT_RESULT_STOP
		Per-event special stop. This stops the event from being handled in the core script.
	
	Const: EVENT_RESULT_SUPPRESS
		Per-event special suppress. This suppresses the event (described per event).

Section: Event Modes

	const: EVENT_MODE_ANY
		allow any mode (default)

	const: EVENT_MODE_SYNC
		sync mode

	const: EVENT_MODE_DEFER
		defer mode
*/

#define event(s) substr(strlwr(s), 0, 32)
#define event_t string
#define event_id_t int

#define EVENTS_MAX_SERIAL 125
#define EVENTS_LVAR_PREFIX "_ev_"

// Struct: EventInfo
// A struct containing various information
// relating the event.
struct EventInfo {

	// Var: mode
	// The EVENT_MODE_*
	int mode;

	// Var: ev
	// The event
	event_t ev;

	// Var: ev_id
	// This events unique id, used to keep track of internal variables.
	event_id_t serial;

	// Var: defer_time
	// How many seconds this event is late
	float defer_time;

	// Var: r_pos
	// The position in the run queue.
	int r_pos;

	// Var: r_total
	// The number of scripts scheduled to run in total.
	int r_total;

	// Var: runnable
	// The object this event runs on, usually OBJECT_SELF
	object runnable;

	// Var: actor
	// The actor of the event
	object actor;

	// Var: actedon
	// the object the event acted on
	object actedon;

	// Var: actedat
	// The location where the event took place
	location actedat;
};


// Struct: EventArguments
// A struct containing arguments passed by the
// event source. Refer to the individual event
// documentation to find out the meaning and
// contents of each argument.
// Yes, this is ugly.
// Improvements welcome.
struct EventArguments {
	// Used internally.
	bool do_not_set;

	// Var: modified
	// Have the arguments been modified by a script?
	bool modified;

	// Vars: a0, a1, a2
	string a0, a1, a2;
	// Vars: i0, i1, i2
	int i0, i1, i2;
	// Vars: f0, f1, f2
	float f0, f1, f2;
	// Vars: o0, o1, o2
	object o0, o1, o2;
	// Vars: l0, l1, l2
	location l0, l1, l2;
};


const int EVENT_SCRIPT_LENGTH = 16;

const int EVENT_RESULT_FAIL = 1 << 0;
const int EVENT_RESULT_END = 1 << 1;
const int EVENT_RESULT_STOP  = 1 << 2;
const int EVENT_RESULT_SUPPRESS = 1 << 3;

const int EVENT_MODE_ANY = 1 << 0;
const int EVENT_MODE_SYNC = 1 << 1;
const int EVENT_MODE_DEFER = 1 << 2;

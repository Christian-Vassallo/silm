#include "inc_pc_data"
#include "inc_pc_mnxnotify"

void main() {
	save_player(OBJECT_SELF);
	notify_pc_logout(OBJECT_SELF);
}

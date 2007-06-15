#include "inc_pgsql"

void main() {


	//pQ(
	//	"update accounts set total_time=total_time + unix_timestamp() - (select sum(current_time) from characters where characters.account = accounts.id);");


	pQ(
		"update characters set total_time = total_time + (now() - login_time), login_time=null where login_time <> null;");
}

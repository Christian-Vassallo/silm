#include "inc_mysql"

void main() {


	SQLQuery(
		"update `accounts` set `total_time`=`total_time` + unix_timestamp() - (select sum(`current_time`) from `characters` where `characters`.`account` = `accounts`.`id`);");


	SQLQuery(
		"update `characters` set `total_time`=`total_time` + (unix_timestamp() - `current_time`), `current_time`=0 where `current_time` > 0;");
}

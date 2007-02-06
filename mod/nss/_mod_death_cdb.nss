#include "inc_mysql"
#include "inc_cdb"

void main() {

	object oKilled = GetLastPlayerDied();
	object oKiller = GetLastDamager(oKilled);

	if ( !GetIsPC(oKilled) || !GetIsPC(oKiller) )
		return;

	int nIDKilled = GetCharacterID(oKilled),
		nIDKiller = GetCharacterID(oKiller);

	SQLQuery("insert into `kills_pc` (`killer`, `killee`, `date`, `area`) values('" +
		IntToString(nIDKiller) +
		"', '" + IntToString(nIDKilled) + "', now(), " + SQLEscape(GetResRef(GetArea(oKilled))) + ");");
}

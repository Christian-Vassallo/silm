/*
 * File: _map
 * Saving and restoring mappins from/to a
 * MySQL-compatible database.
 * Copyright Bernard 'elven' Stoeckner.
 *
 * This code is licenced under the
 *  GNU/GPLv2 General Public Licence.
 */

/* auskommentiert bis ich es repariert hab mal */

#include "inc_mysql"
#include "_gen"
#include "inc_cdb"

const string PINDB = "mappins";
/*
 * DROP TABLE IF EXISTS `tab_mappins`;
 * CREATE TABLE IF NOT EXISTS `tab_mappins` (
 * `id` bigint(20) NOT NULL auto_increment,
 * `account` varchar(250) NOT NULL default '',
 * `charname` text NOT NULL,
 * `text` text NOT NULL,
 * `x` float NOT NULL default '0',
 * `y` float NOT NULL default '0',
 * `area` varchar(250) NOT NULL default '',
 * PRIMARY KEY  (`id`),
 * KEY `account` (`account`)
 * ) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1;
 */


// Saves all MapPins for player oPC,
// deleting the old ones.
int SaveMapPinsForPlayer(object oPC);

// Restores all MapPins for player oPC.
// Deleting the ones already there on
// the player.
int RestoreMapPinsForPlayer(object oPC);


/* impl */


int SaveMapPinsForPlayer(object oPC) {
	int nCID = GetCharacterID(oPC);

	if ( nCID == 0 )
		return 0;

	string sCID = IntToString(nCID);

	/* First, delete the old ones in the Database. */
	SQLExecDirect("delete from `" + PINDB + "` where `character` = " + sCID + ";");

	int count = GetLocalInt(oPC, "NW_TOTAL_MAP_PINS");

	int i, notsaved = 0;
	for ( i = 1; i <= count; i++ ) {
		object
		oArea = GetLocalObject(oPC, "NW_MAP_PIN_AREA_" + IntToString(i));
		string
		s = SQLEscape(GetLocalString(oPC, "NW_MAP_PIN_NTRY_" + IntToString(i))),
		a = SQLEscape(GetTag(oArea));
		float
		x = GetLocalFloat(oPC, "NW_MAP_PIN_XPOS_" + IntToString(i)),
		y = GetLocalFloat(oPC, "NW_MAP_PIN_YPOS_" + IntToString(i));

		if ( !GetIsObjectValid(oArea) ) {
			//SendMessageToPC(oPC, "Du hast einen ungueltigen Pin platziert, ich ignoriere ihn.");
			// wont see it anyways on logout
			notsaved += 1;
			continue;
		}

		SQLExecDirect(
			"insert into `" + PINDB + "` (`character`,`text`,`x`,`y`,`area`) " +
			"values(" +
			sCID + ", " + s + ", '" + FloatToString(x) + "', '" + FloatToString(y) + "', " + a + ");"
		);
	}
	return count - notsaved;
}

int RestoreMapPinsForPlayer(object oPC) {
	int nCID = GetCharacterID(oPC);

	if ( nCID == 0 )
		return 0;

	string sCID = IntToString(nCID);


	SQLExecDirect("select `text`,`x`,`y`,`area` from `" +
		PINDB + "` where `character` = '" + sCID + "' limit 500;");

	int count = 0;

	while ( SQLFetch() == SQL_SUCCESS ) {
		string
		s = SQLGetData(1),
		a = SQLGetData(4);
		float
		x = StringToFloat(SQLGetData(2)),
		y = StringToFloat(SQLGetData(3));
		object
		oa = GetObjectByTag(a);

		if ( !GetIsObjectValid(oa) ) {
			//SendMessageToPC(oPC, "Du hattest einen ungueltigen Mappin in der DB, ich ignoriere ihn. " +
			//    "(Tag = '" + a + "')."); /* gets deleted on next save automagically */
			continue;
		}
		count += 1;

		SetLocalString(oPC, "NW_MAP_PIN_NTRY_" + IntToString(count), s);
		SetLocalFloat(oPC, "NW_MAP_PIN_XPOS_" + IntToString(count), x);
		SetLocalFloat(oPC, "NW_MAP_PIN_YPOS_" + IntToString(count), y);
		SetLocalObject(oPC, "NW_MAP_PIN_AREA_" + IntToString(count), oa);
	}

	SetLocalInt(oPC, "NW_TOTAL_MAP_PINS", count);

	return count;
}

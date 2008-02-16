/***************************************************************************
    odmbc plugin for NWNX - Implementation of the CNWNXodmbc class.
    copyright (c) 2006 dumbo (dumbo@nm.ru) & virusman (virusman@virusman.ru)

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 ***************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <pthread.h>
#include <stddef.h>

#include "NWNXodmbc.h"
#include "HookSCORCO.h"
#include "mysql.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CNWNXodmbc::CNWNXodmbc()
{
	confKey = "ODBC2";

	request_counter = 0;
	sqlerror_counter = 0;
	scorcoSQL = 0;
	db = 0;
	dbType = dbNONE;
	hookScorco = true;
	memset (&p, 0, sizeof (PARAMETERS));
}
//============================================================================================================================

CNWNXodmbc::~CNWNXodmbc()
{
	OnRelease ();
}

//============================================================================================================================

bool CNWNXodmbc::OnCreate (gline *config, const char* LogDir)
{
	char log[128];
	bool validate = true, startServer = true;

	// call the base class function
	sprintf (log, "%s/nwnx_odmbc.txt", LogDir);
	if (!CNWNXBase::OnCreate(config,log))
		return false;

	// write copy information to the log file
	Log (0, "NWNX2 ODBC2 version 0.3.1 for Linux.\n");
	Log (0, "(c) 2005-2006 by dumbo (dumbo@nm.ru) & virusman (virusman@virusman.ru)\n");

  if (!LoadConfiguration())
    return false;

  if (hookScorco)
	{
		scorcoSQL = (char*) malloc(MAXSQL);
		int ret = HookFunctions();
		if (!ret) return ret;
	}

	return Connect();
}

//============================================================================================================================

BOOL CNWNXodmbc::Connect()
{
	BOOL connected;
// CODBC* odbc;
	CMySQL* mysql;
#if SQLITE_SUPPORT == 1
	CSQLite* sqlite;
#endif
#if PGSQL_SUPPORT == 1
	CPgSQL* pgsql;
#endif



	// create a database instance
	switch (dbType)
	{
		case dbMYSQL:
			mysql = new CMySQL();
			connected = mysql->Connect(p.server, p.user, p.pass, p.db, p.charset);
			db = mysql;
			break;
#if SQLITE_SUPPORT == 1
		case dbSQLITE:
			sqlite = new CSQLite();
			connected = sqlite->Connect(p.db);
			db = sqlite;
			break;
#endif
#if PGSQL_SUPPORT == 1
		case dbPGSQL:
			pgsql = new CPgSQL();
			connected = pgsql->Connect(p.server, p.user, p.pass, p.db);
			db = pgsql;
			break;
#endif
	}

	// try to connect to the database
	if (!connected)
	{
		Log (0, "! Error while connecting to database: %s\n", db->GetErrorMessage ());
		return false;
	}

	// we successfully connected
	Log (0, "o Connect successful.\n");
	return true;
}

//============================================================================================================================
char* CNWNXodmbc::OnRequest (char* gameObject, char* Request, char* Parameters)
{
	if (strncmp (Request, "EXEC", 4) == 0)
		Execute(Parameters);
	else if (strncmp (Request, "FETCH", 5) == 0)
		Fetch (Parameters, strlen (Parameters));
	else if (strncmp(Request, "SETSCORCOSQL", 12) == 0)
		SetScorcoSQL(Parameters);
	else if (strncmp(Request, "GETERRORMSG", 11) == 0)
		GetErrorMessage(Parameters);
	return NULL;
}

//============================================================================================================================
void CNWNXodmbc::GetErrorMessage(char *buffer) {
	memcpy(buffer, db->GetErrorMessage(), strlen(db->GetErrorMessage()) + 1);
}

//============================================================================================================================
void CNWNXodmbc::Execute(char *request)
{
  Log (2, "o Got request: %s\n", request);
	request_counter++;
	
	// try to execute the SQL query
	BOOL ret = db->Execute((const uchar*)request);
	if (!ret)
		Log (1, "! SQL Error: %s\n", db->GetErrorMessage ());

	sprintf(request, "%d", ret);
}

//============================================================================================================================
void CNWNXodmbc::Fetch(char *buffer, unsigned int buffersize)
{
	unsigned int totalbytes = 0;
	buffer[0] = 0x0;
	// fetch data from recordset
	totalbytes = db->Fetch (buffer, buffersize);
  // log what we received
  if (totalbytes == -1)
    Log (2, "o Empty set\n");
  else
    Log (2, "o Sent response (%d bytes): %s\n", totalbytes, buffer);
}

//============================================================================================================================
void CNWNXodmbc::SetScorcoSQL(char *request)
{
	memcpy(scorcoSQL, request, strlen(request) + 1);
	Log (2, "o Got request (scorco): %s\n", scorcoSQL);
}

//============================================================================================================================
bool CNWNXodmbc::OnRelease ()
{
  Log (0, "o Shutdown.\n");

  if (db) db->Disconnect ();

	if (scorcoSQL)
    free(scorcoSQL);

	// release the server
	if (p.server)
		free (p.server);

	// release memory
	if (dbType == dbMYSQL || dbType == dbPGSQL)
	{
		free (p.user);
		free (p.pass);
		free (p.db);
	}
}

//============================================================================================================================
int CNWNXodmbc::WriteSCO(char* database, char* key, char* player, int flags, unsigned char * pData, int size)
{
  Log(3, "o SCO: db='%s', key='%s', player='%s', flags=%08lX, pData=%08lX, size=%08lX\n", database, key, player, flags, pData, size);

  if (size > 0)
	{
		//Log ("o Writing scorco data.\n");
		if (!db->WriteScorcoData(scorcoSQL, pData, size))
      Log (1, "! SQL Error: %s\n", db->GetErrorMessage ());
    else
      return 1;
	}
  return 0;
}

//============================================================================================================================
unsigned char* CNWNXodmbc::ReadSCO(char* database, char* key, char* player, int* arg4, int* size)
{
  *arg4 = 0x4f;

  Log(3, "o RCO(0): db='%s', key='%s', player='%s', arg4=%08lX, size=%08lX\n", database, key, player, arg4, size);

	BYTE* pData;
	BOOL sqlError;

	//Log ("o Reading scorco data.\n");
	pData = db->ReadScorcoData(scorcoSQL, key, &sqlError, size);

  Log(3, "o RCO(1): db='%s', key='%s', player='%s', arg4=%08lX, size=%08lX\n", database, key, player, *arg4, *size);
  Log(3, "o RCO(2): err=%lX, pData=%08lX, pData='%s'\n", sqlError, pData, pData);

  if (!sqlError && pData)
		return pData;
	else
	{
		if (sqlError)
			Log (1, "! SQL Error: %s\n", db->GetErrorMessage ());
	}
  return NULL;
}

//============================================================================================================================
bool CNWNXodmbc::LoadConfiguration ()
{
	char buffer[256];

	if(!nwnxConfig->exists(confKey)) {
		Log (0, "o Critical Error: Section [%s] not found in NWNX.INI\n", confKey);
		return false;
  }

  // see what mode should be used
	strcpy(buffer, (char*)((*nwnxConfig)[confKey]["source"].c_str()));

  if (strcasecmp (buffer, "MYSQL") == 0) {
		// load in the settings for a direct mysql connection
		p.server    = strdup((char*)((*nwnxConfig)[confKey]["server"].c_str()));
		p.user      = strdup((char*)((*nwnxConfig)[confKey]["user"].c_str()));
		p.pass      = strdup((char*)((*nwnxConfig)[confKey]["pass"].c_str()));
		if(!*p.pass)
		p.pass      = strdup((char*)((*nwnxConfig)[confKey]["pwd"].c_str()));
		p.db        = strdup((char*)((*nwnxConfig)[confKey]["db"].c_str()));
		p.charset   = strdup((char*)((*nwnxConfig)[confKey]["charset"].c_str()));
		dbType = dbMYSQL;
	}
/*
  else if (strcasecmp (buffer, "ODBC") == 0) {
		p.server = strdup((char*)((*nwnxConfig)[confKey]["dsn"].c_str()));
		dbType = dbODBC;
	}*/
#if SQLITE_SUPPORT==1
	else if (strcasecmp (buffer, "SQLITE") == 0) {
		// load in the settings for the internal database
		p.db = strdup((char*)((*nwnxConfig)[confKey]["file"].c_str()));
		dbType = dbSQLITE;
	}
#endif
#if PGSQL_SUPPORT==1
	else if (strcasecmp (buffer, "PGSQL") == 0) {
		  // load in the settings for a direct pgsql connection
		  p.server	  = strdup((char*)((*nwnxConfig)[confKey]["server"].c_str()));
		  p.user	  = strdup((char*)((*nwnxConfig)[confKey]["user"].c_str()));
		  p.pass	  = strdup((char*)((*nwnxConfig)[confKey]["pass"].c_str()));
		  if(!*p.pass)
		  p.pass	  = strdup((char*)((*nwnxConfig)[confKey]["pwd"].c_str()));
		  p.db		  = strdup((char*)((*nwnxConfig)[confKey]["db"].c_str()));
		  dbType = dbPGSQL;
	  }
#endif
	else {
#if SQLITE_SUPPORT==1
		Log (0, "o Critical Error: Datasource must be MySQL or SQLite.\n");
#endif
#if PGSQL_SUPPORT==1
		Log (0, "o Critical Error: Datasource must be MySQL or PGSQL.\n");
#else
		Log (0, "o Critical Error: Datasource must be MySQL.\n");
#endif
		dbType = dbNONE;
		return false;
	}

	// check if scorco should be hooked
	strcpy(buffer, (char*)((*nwnxConfig)[confKey]["hookscorco"].c_str()));
	if (strcasecmp (buffer, "false") == 0)
		hookScorco = false;

	return true;
}

//============================================================================================================================

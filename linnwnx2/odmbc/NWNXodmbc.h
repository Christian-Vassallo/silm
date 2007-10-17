/***************************************************************************
    odmbc plugin for NWNX - interface for the CNWNXChat class.
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

#ifndef _NWNX_odmbc_H_
#define _NWNX_odmbc_H_

#define SQLITE_SUPPORT 0

#include "../NWNXBase.h"
#include "../gline.h"
#include "db.h"
#include "mysql.h"
#include "pgsql.h"
#if SQLITE_SUPPORT == 1
#include "sqlite.h"
#endif
#include "HookSCORCO.h"

class CNWNXodmbc : public CNWNXBase
{

public:
	CNWNXodmbc();
	~CNWNXodmbc();
	bool OnCreate(gline *config, const char* LogDir);
	char* OnRequest(char* gameObject, char* Request, char* Parameters);
	bool OnRelease();

  int WriteSCO(char* database, char* key, char* player, int flags, unsigned char * pData, int size);
  unsigned char* ReadSCO(char* database, char* key, char* player, int* arg4, int* size);

protected:
	BOOL Connect();
	void Execute(const char* request);
	void Fetch(char* buffer, unsigned int buffersize);
	void SetScorcoSQL(char *request);
	bool LoadConfiguration ();

private:
  CDB* db;
	enum EDBType {dbNONE, dbODBC, dbMYSQL, dbSQLITE};
	int dbType;

	struct PARAMETERS {
		char *server;
		char *user;
		char *pass;
		char *db;
		char *charset;
	} p;

	unsigned int request_counter;
	unsigned int sqlerror_counter;

	bool hookScorco;
	char* scorcoSQL;

	enum ELogLevel {logNothing, logErrors, logAll};
};

#endif

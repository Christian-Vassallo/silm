/***************************************************************************
    NWNX FOR LINUX DB CLASSES 
    Original idea by: Ingmar Stieger (Papillon) papillon@blackdagger.com
    Copyright (C) 2003 Mirko Bernardoni (Firedeath)
    email: firedeath@ghostnight.net

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

#ifndef __DBPGSQL_H__
#define __DBPGSQL_H__

#include "data.h"
#include <string.h>
#include <postgresql/libpq-fe.h>

class DbPgSql:public Data
{
  public:
    DbPgSql (ConnParam *p=NULL);
    virtual ~ DbPgSql ();
    virtual bool SqlConn (ConnParam *p=NULL);	// Allocate env, stat, and conn
    virtual unsigned int SqlExec (unsigned char *cmdstr, char *buffer, unsigned int buffersize);	// Execute SQL statement
    virtual void SqlDisconn ();	// Free pointers to env, stat, conn, and disconnect
    virtual unsigned int SqlFetch (char *buffer, unsigned int buffersize);	// Fetch One single row in table
    virtual bool ProcessRequest (char *request, unsigned int responseSize);	//Initializze the db request
  private:
    PGconn *pgsql;
    PGresult *result;
    unsigned long NumCol, CurCol;
  protected:
      virtual void SqlExec (char *buffer, unsigned int buffersize);	// Called by ProcessRequest
      virtual void CheckAndReconnect();
};


#endif


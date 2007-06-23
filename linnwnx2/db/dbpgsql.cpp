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

#include <stdio.h>
#include "dbpgsql.h"

DbPgSql::DbPgSql (ConnParam *p) // Set the connexion parameters
{
  error = false;
  connValid = ERR_NOTCONNECTED;	
  debugLevel=DBG_NO;
  stream=stderr;
  SetConnParams(p);
}

DbPgSql::~DbPgSql () // Destructor
{
  PQfinish (pgsql);
}

bool DbPgSql::SqlConn (ConnParam * p) // Try to connect
{
  error = false;
  connValid = ERR_NOTCONNECTED;	

  SetConnParams(p);

  if( connParams.user==NULL && 
      connParams.pass==NULL &&
      connParams.server==NULL &&
      connParams.db==NULL)
    {
      error = true;
      errorString = "No credentials supplied";
      fprintf(stream,"o ERROR: %s\n", errorString);
      return false;
    }

#define HOST	"host="
#define PORT	"port="
#define DB	"dbname="
#define USR	"user="
#define PW	"password="
#define PORT_NUM	5432

  char *connstring = (char *)malloc(strlen(HOST)
				    + strlen(PORT)
				    + strlen(DB)
				    + strlen(USR)
				    + strlen(PW)
				    + 20
				    + strlen(connParams.server)
				    + strlen(connParams.db)
				    + strlen(connParams.user)
				    + strlen(connParams.pass));
  // Build the connexion string
  sprintf(connstring, HOST"%s "PORT"%hu "DB"%s "USR"%s "PW"%s", connParams.server, PORT_NUM, connParams.db, connParams.user, connParams.pass);

  // Connect attempt
  pgsql = PQconnectdb(connstring);
  if (PQstatus(pgsql) != CONNECTION_OK)
    {
      error = true;
      errorString = "Unable to connect to PgSQL database";
      fprintf(stream,"o ERROR: %s '%s' with error %s.\n", errorString, PQdb(pgsql), PQerrorMessage(pgsql));
      return false;
    }

  free(connstring);

  connValid = ERR_NOTQUERY;	
  return true;
}

void
DbPgSql::SqlDisconn () // Disconnect
{
  error = false;
  connValid = ERR_NOTCONNECTED;
  PQfinish(pgsql);
}

unsigned int // The never-called function, who cares ? perhaps buggy but ...
DbPgSql::SqlExec (unsigned char *cmdstr, char *buffer,
		  unsigned int buffersize)
{
  unsigned int totalbytes = 0, row_len = 0;
  unsigned long NumCol, i, j;
  char *row;
  if (connValid == ERR_NOTCONNECTED)
    {
      errorString = "DB not connected";
      fprintf(stream,"o ERROR: %s\n", errorString);
      error = true;
      return 0;
    }

  if (debugLevel == DBG_YES)
    fprintf(stream,"o Got request: %s\n", cmdstr);
  error = false;
  buffer[0] = '\0';		// same as strcpy but more efficently
  connValid = ERR_NOTQUERY;

  result = PQexec(pgsql, (const char *) cmdstr);
  if (PQresultStatus(result) != PGRES_TUPLES_OK)
    {
      error = true;
      errorString = (char *) PQerrorMessage(pgsql);
      fprintf(stream, "o ERROR: %s", errorString);
      PQclear(result);
      if (strlen(errorString) < buffersize)
	strcpy (buffer, errorString);
      else
	strncpy (buffer, errorString, buffersize);
      return 0;
    }

  NumCol = PQnfields(result);

  if (NumCol == 0) {
    if (debugLevel==DBG_YES)
      fprintf(stream, "o Empty set\n");
    return 0;
  }

  for (i = 0; i < PQntuples(result); i++)
    for (j = 0; j < NumCol; j++) {
      row = PQgetvalue(result, i, j);
      row_len = strlen(row);
      if (totalbytes + row_len + 1 <= buffersize) {
	strcat(buffer, row);
	strcat(buffer, "¬");
	totalbytes += row_len + 1;
      }
    }
  // Remove the last char
  buffer[totalbytes-1]='\0';
  totalbytes--;

  if (debugLevel == DBG_YES)
    fprintf(stream, "o Sent response (%d bytes): %s\n", totalbytes, buffer);

  return (unsigned int) totalbytes;
}

// Fetch a row
unsigned int
DbPgSql::SqlFetch (char *buffer, unsigned int buffersize)
{
  unsigned int totalbytes = 0, row_len=0;
  unsigned long j;
  char *row;
  buffer[0] = '\0';

  if (connValid != ERR_OK) {
    errorString = "Connection not valid";
    fprintf(stream,"o ERROR: %s\n", errorString);
    error = true;
  }
  if(error || connValid != ERR_OK)
    return 0;
    
  // Ensure the previous request succeed
  if (PQresultStatus(result) == PGRES_FATAL_ERROR)
    {
      error = true;
      errorString = (char *) PQerrorMessage(pgsql);
      fprintf(stream, "o ERROR: %s", errorString);
      if (strlen(errorString) < buffersize)
	strcpy (buffer, errorString);
      else
	strncpy (buffer, errorString, buffersize);
      return 0;
    }
    
  // Check for empty set
  if ((NumCol = PQnfields(result)) == 0) {
    if (debugLevel == DBG_YES)
      fprintf(stream, "o Empty set\n");
    return 0;
  }
    
  // Not empty, fill the buffer
  if (PQntuples(result) > CurCol)
    for (j = 0; j < NumCol; j++) {
      row = PQgetvalue(result, CurCol, j);
      row_len = strlen(row);
      if (totalbytes + row_len + 1 <= buffersize) {
	strcat(buffer, row);
	strcat(buffer, "¬");
	totalbytes += row_len + 1;
      }
    }
  // Remove the last char
  buffer[totalbytes-1]='\0';
  totalbytes--;
	
  // Increment the CurCol cursor
  CurCol++; 
  if (debugLevel == DBG_YES)
    {
      if (totalbytes > 0)
	fprintf(stream, "o Sent response (%d bytes): %s\n", totalbytes, buffer);
      else
	fprintf(stream, "o Empty set\n");
    }
  error = false;
  return (unsigned int) totalbytes;
}

// Exec an sql request
void
DbPgSql::SqlExec (char *buffer, unsigned int buffersize)
{
  if (connValid == ERR_NOTCONNECTED)
    {
      errorString = "DB not connected";
      fprintf(stream,"o ERROR: %s\n", errorString);
      error = true;
      return;
    }
        
  connValid = ERR_NOTQUERY;
   
  // Execute the request
  result = PQexec(pgsql, (const char *) buffer);
  if (PQresultStatus(result) == PGRES_FATAL_ERROR)
    {
      error = true;
      errorString = (char *) PQerrorMessage(pgsql);
      fprintf(stream, "o ERROR: %s", errorString);
      if (strlen(errorString) < buffersize)
	strcpy (buffer, errorString);
      else
	strncpy (buffer, errorString, buffersize);
      return;
    }

  // Set the CurCol cursor to 0    
  CurCol = 0;

  if ((NumCol = PQnfields(result)) == 0) {
    if (debugLevel == DBG_YES)
      fprintf(stream, "o Empty set\n");
    return;
  }

  error = false;
  connValid = ERR_OK;
  buffer[0] = '\0';
}

bool DbPgSql::ProcessRequest(char *request, unsigned int responseSize)
{
  // if not connected try to reconnect
  if(connValid == ERR_NOTCONNECTED && !SqlConn()) {
    // SqlConn() will set the errorString for us
    return false;
  }

  // free the last results set
  if(result != NULL) {
    PQclear(result);
    result = NULL;
  }

  // DB crash proof
  CheckAndReconnect();
  
  if(debugLevel == DBG_YES)
    fprintf(stream,"o Got request: %s\n", request);
  SqlExec(request, responseSize - 1);
  return !error;
}

void DbPgSql::CheckAndReconnect()
{
  // Problem occurs, attempt to reconnect
  if(PQstatus(pgsql)==CONNECTION_BAD || PQsocket(pgsql)==-1)
    PQreset(pgsql); // Reset the connection properly		
}

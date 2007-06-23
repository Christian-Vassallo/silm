#ifndef NWNXpgsql_h_
#define NWNXpgsql_h_

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h> /* memset() */
#include <sys/time.h> /* select() */ 
#include <errno.h>
#include <signal.h>

#include "db/data.h"
#include "db/dbpgsql.h"

#include "NWNXBase.h"

class CNWNXpgsql : public CNWNXBase
{
public:
	CNWNXpgsql();
	~CNWNXpgsql();

	bool OnCreate(gline *nwnxConfig, const char *LogDir=NULL);
	char *OnRequest(char* gameObject, char* Request, char* Parameters);
	bool OnRelease();

protected:
	bool ClientClose(const char *conn);
	bool ClientInit(const char *conn,const char *dest);

private:
	Data *db;
	// dbdict Connections;
	char pgsql_buf[4096];
};

#endif

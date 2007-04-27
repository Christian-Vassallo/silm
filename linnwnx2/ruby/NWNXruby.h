#ifndef NWNXruby_h_
#define NWNXruby_h_

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

using namespace::std;
#include <iostream>
#include <map>
#include <string>

#include <ruby.h>

#include "NWNXBase.h"

#ifdef __cplusplus
# ifndef RUBY_METHD_FUNC /* These definitions should work for Ruby 1.4.6
*/
# define VALUEFUNC(f) ((VALUE (*)()) f)
# define VIDFUNC(f) ((void (*)()) f)
# else
# ifndef ANYARGS /* These definitions should work for Ruby 1.6 */
# define VALUEFUNC(f) ((VALUE (*)()) f)
# define VIDFUNC(f) ((RUBY_DATA_FUNC) f)
# else /* These definitions should work for Ruby 1.7 */
# define VALUEFUNC(f) ((VALUE (*)(ANYARGS)) f)
# define VIDFUNC(f) ((RUBY_DATA_FUNC) f)
# endif
# endif
#else
# define VALUEFUNC(f) (f)
# define VIDFUNC(f) (f)
#endif


class CNWNXruby : public CNWNXBase {
public:
	CNWNXruby();
	~CNWNXruby();
	bool OnCreate(gline *nwnxConfig, const char *LogDir=NULL);
	char *OnRequest(char* gameObject, char* Request, char* Parameters);

protected:
	bool Configure();

	// Runs some ruby code
	VALUE Ruby(char* Request);
	VALUE FromRuby(VALUE self, VALUE data);
	void Reload();
private:
	char* scriptname;
	char ruby_buf[2048];
};

#endif

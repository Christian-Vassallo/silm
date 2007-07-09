/***************************************************************************
    NWNXFixes.cpp - Implementation of the CNWNXFixes class.
    (c) 2007 virusman (virusman@virusman.ru)

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

#include <string.h>
#include <string>
#include <stdlib.h>

#include "NWNXFixes.h"
#include "FixesHooks.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CNWNXFixes::CNWNXFixes()
{
	confKey = "FIXES";
	bHooked = 0;
}

CNWNXFixes::~CNWNXFixes()
{
}


bool CNWNXFixes::OnCreate(gline *config, const char *LogDir)
{
	char log[128];
	sprintf (log, "%s/nwnx_fixes.txt", LogDir);

	// call the base class function
	if (!CNWNXBase::OnCreate(config,log))
		return false;
	Log(0,"NWNX Fixes V.1.0\n");
	Log(0,"(c) by virusman, 2007\n");
	Log(0,"visit us at http://www.avlis.org\n\n");
	if (FindHookFunctions())
	{
		bHooked=1;
		Log(0,"* Module loaded successfully.\n");
	}		
	else
	{
		bHooked=0;
		Log(0,"* Module loaded successfully.\n");
		Log(0,"* Signature recognition failed. Some functions will be disabled.\n");
		//return false;
	}

	return true;
}

char* CNWNXFixes::OnRequest (char *gameObject, char* Request, char* Parameters)
{
	Log(2,"Request: \"%s\"\n",Request);
	Log(3,"Params:  \"%s\"\n",Parameters);

	if (strncmp(Request, "SETGOLDPIECEVALUE", 17) == 0) 	
	{
	}
	return NULL;
}

unsigned long CNWNXFixes::OnRequestObject (char *gameObject, char* Request)
{
	return OBJECT_INVALID;
}

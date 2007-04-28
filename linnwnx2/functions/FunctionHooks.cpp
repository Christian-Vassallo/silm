/***************************************************************************
    Functions plugin for NWNX  - hooks implementation
    (c) 2005 virusman (virusman@virusman.ru)

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

#include <sys/types.h>
#include <sys/mman.h>
#include <dlfcn.h>
#include <stdarg.h>

#include <limits.h>		/* for PAGESIZE */
#ifndef PAGESIZE
#define PAGESIZE 4096
#endif

#include "FunctionHooks.h"
#include "NWNXFunction.h"
#include "AssemblyHelper.cpp"

extern CNWNXFunction functions;
AssemblyHelper asmhelp;

//Functions:
//Return value: 0 upon success, 1 upon failure
int (*pGetObjByOID)(void *pServerExo,long ObjID,void *buf);
void *(*pRetObjByOID)(void *pServerExo,long ObjID);
//Return value: 1 upon success, 0 upon failure
int (*pGetFaction)(void *pServerExo,long ObjID,int *buf);
void *(*pGetFactionEntry)(void *pFactionClass,int nFaction);
void (*pChangeFaction)(void *pFactionEntry,int ObjID,int unk);
void *(*pGetObjectFactionEntry)(void *pObject);
long (*pGetFactionLeader)(void *pFactionEntry);
void *(*pGetAreaByID)(void *pServerExo, dword nAreaID);
float (*pGetZCoordinate)(void *pArea, float X, float Y, float Z);
int (*pGetIsWalkable)(void *pArea, float X, float Y, float Z, void *pSomePositionStruct);
void *(*pGetModule)(void *pServerExo4);

//Constants:

void *pServer = 0;
void *pServerExo = 0;
void *pServerExo4 = 0;
void *pFactionClass = 0;
//dword pScriptThis = 0;
//dword oPC = 0;

unsigned char d_jmp_code[] = "\x68\x60\x70\x80\x90"       /* push dword 0x90807060 */
                             "\xc3\x90\x90\x90\x90";//x00 /* ret , nop , nop       */

unsigned char d_ret_code[0x20];

unsigned long lastRet;

long GetOIDByObj(void *pObject)
{
	return *((dword*)pObject+0x4);
}

int GetFaction(long ObjID,int *buf)
{
	if(!functions.bHooked) return -1;
	if(!pServer) InitConstants();
	return pGetFaction(*((void **)pServerExo+1), ObjID, buf);
}

void SetFaction(long ObjID, int nFaction)
{
	if(!functions.bHooked) return;
	if(!pServer) InitConstants();
	void *pFactionEntry = pGetFactionEntry(pFactionClass, nFaction);
	pChangeFaction(pFactionEntry, ObjID, 0);
}

void *GetAreaByID(dword nAreaID)
{
	if(!functions.bHooked) return NULL;
	if(!pServer) InitConstants();
	return pGetAreaByID(*((void **)pServerExo+1), nAreaID);
}

float GetZCoordinate(void *pArea, float X, float Y, float Z)
{
	return pGetZCoordinate(pArea, X, Y, Z);
}

int GetIsWalkable(void *pArea, float X, float Y, float Z)
{
	void *pSomePositionStruct = *(void **)((char*)pArea+0x198);
	if(!pSomePositionStruct)
	{
		functions.Log(0, "Null. :(");
	}
	return pGetIsWalkable(pArea, X, Y, Z, pSomePositionStruct);
}

void *GetModule()
{
	if(!functions.bHooked) return NULL;
	if(!pServer) InitConstants();
	void *pModule = pGetModule(pServerExo4);
	return pModule;
}

int FindFunctions()
{
	//Version check
	/*char *build;
	*(dword*)&build = 0x08308EE3;
	functions.Log(2, "Version: ");
	functions.Log(2, "%s\n", build);
	if(strncmp(build, "8093", 4)!=0) return false;
	functions.Log(2, "Checked\n");*/

	//Functions
	//*(dword*)&pGetObjByOID =				0x080B8EDC;
	//*(dword*)&pRetObjByOID =				0x080B0378;
	//*(dword*)&pGetFaction =				0x080B0AF0;
	//*(dword*)&pGetFactionEntry =			0x080B85B0;
	//*(dword*)&pChangeFaction =			0x081D3794;
	//*(dword*)&pGetObjectFactionEntry =	0x081109B0;
	//*(dword*)&pGetFactionLeader =			0x081D49A8;
	//*(dword*)&pGetZCoordinate =			0x080D40D0;
	//*(dword*)&pGetAreaByID =				0x080B03A8;  //0x080AEA1C
	//*(dword*)&pGetIsWalkable =			0x080D427C;
	*(dword*)&pGetFaction =	asmhelp.FindFunctionBySignature("55 89 E5 56 53 ** ** ** 8D 45 F4 50 8B 55 0C");
	functions.Log(2, "GetFaction: %08lX\n", pGetFaction);
	*(dword*)&pGetFactionEntry = asmhelp.FindFunctionBySignature("55 89 E5 ** ** ** 8B 55 0C 85 D2 8B 4D 08 78");
	functions.Log(2, "GetFactionEntry: %08lX\n", pGetFactionEntry);
	*(dword*)&pChangeFaction = asmhelp.FindFunctionBySignature("55 89 E5 57 56 53 ** ** ** A1 ** ** ** ** 8B 40 04 FF 75 0C 50 89 45 F0");
	functions.Log(2, "ChangeFaction: %08lX\n", pChangeFaction);
	*(dword*)&pGetObjectFactionEntry = asmhelp.FindFunctionBySignature("55 89 E5 ** ** ** A1 ** ** ** ** 8B 40 04 8B 55 08 8B 48 04 8B 82 64 0C 00 00 FF B0 88 00 00 00");
	functions.Log(2, "GetObjectFactionEntry: %08lX\n", pGetObjectFactionEntry);
	*(dword*)&pGetFactionLeader = asmhelp.FindFunctionBySignature("55 89 E5 57 56 53 ** ** ** A1 ** ** ** ** C7 45 F0 00 00 00 7F 8B 40 04 89 45 EC FF 75 08");
	functions.Log(2, "GetFactionLeader: %08lX\n", pGetFactionLeader);
	*(dword*)&pGetZCoordinate = asmhelp.FindFunctionBySignature("55 89 E5 57 56 53 ** ** ** 31 D2 8B 3D ** ** ** ** BB FF FF FF FF 39 FA 89 DE 7D");
	functions.Log(2, "GetZCoordinate: %08lX\n", pGetZCoordinate);	
	*(dword*)&pGetAreaByID = asmhelp.FindFunctionBySignature("55 89 E5 8D 45 FC ** ** ** 50 8B 55 0C 52 8B 4D 08 FF B1 80 00 01 00 C7 45 FC 00 00 00 00 +41 FF 50 30");
	functions.Log(2, "GetAreaByID: %08lX\n", pGetAreaByID);
	*(dword*)&pGetIsWalkable = asmhelp.FindFunctionBySignature("55 89 E5 57 56 53 81 EC ** ** ** ** 8B 55 18 D9 42 04 D9 45 0C 8B 45 08");
	functions.Log(2, "GetIsWalkable: %08lX\n", pGetIsWalkable);
	*(dword*)&pGetModule = asmhelp.FindFunctionBySignature("55 89 E5 8D 45 FC 83 EC 0C 8B 55 08 50 FF B2 84 00 01 00 FF B2 80 00 01 00 C7 45 FC 00 00 00 00 E8");
	functions.Log(2, "GetModule: %08lX\n", pGetModule);

	if(!(pGetFaction && pGetFactionEntry && pChangeFaction && pGetObjectFactionEntry &&
		pGetFactionLeader && pGetZCoordinate && pGetAreaByID && pGetIsWalkable && pGetModule))
	{
		functions.Log(2, "Some of the functions could not be found\n");
		return false;
	}
	functions.Log(2, "All functions set\n");
	return true;
}

void InitConstants()
{
	//Constants
	dword *ppServer = *(dword**)((char *)pGetObjectFactionEntry+0x7);
	//functions.Log(2, "ppServer=%08lX", ppServer);
	//*(dword*)&ppServer = 0x083281D4;
	*(dword*)&pServer = *ppServer;
	*(dword*)&pServerExo = *(dword*)((char*)pServer+0x4);
	*(dword*)&pServerExo4 = *(dword*)((char*)pServerExo+0x4);


	//Да, я знаю, я извращенец!
	*(dword*)&pFactionClass = *(dword*)(*(dword*)((char*)pServerExo+0x4)+0x10074);
}


/***************************************************************************
    Fixes plugin for NWNX  - hooks implementation
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

#include <sys/types.h>
#include <sys/mman.h>
#include <dlfcn.h>
#include <stdarg.h>

#include <limits.h>		/* for PAGESIZE */
#ifndef PAGESIZE
#define PAGESIZE 4096
#endif

#include "FixesHooks.h"
#include "NWNXFixes.h"
#include "NWNStructures.h"
#include "AssemblyHelper.cpp"

extern CNWNXFixes fixes;
AssemblyHelper asmhelp;

//Functions:
//Return value: 0 upon success, 1 upon failure
int (*pGetObjByOID)(void *pObjectClass,dword ObjID,void **buf);
void *(*pGetPlayer)(void *pServerExo4, dword ObjID);
void *(*pGetObjectFactionEntry)(void *pObject);
int (*pGetIsMergeable)(void *pItem1, void *pItem2);
//Constants:

void *pServer = 0;
void *pServerExo = 0;
void *pServerExo4 = 0;
void *pObjectClass = 0;
void *pFactionClass = 0;
void *pClientClass = 0;
void *pRules = 0;
void *p2das = 0;
//dword pScriptThis = 0;
//dword oPC = 0;

unsigned char d_jmp_code[] = "\x68\x60\x70\x80\x90"       /* push dword 0x90807060 */
                             "\xc3\x90\x90\x90\x90";//x00 /* ret , nop , nop       */
unsigned char d_ret_code_merg[0x20];

unsigned long lastRet;

//#################### ENGINE FUNCTIONS ####################

void *GetObjectByID(dword ObjID)
{
	if(!fixes.bHooked) return NULL;
	if(!pServer) InitConstants();
	void *pObject;
	pGetObjByOID(pObjectClass, ObjID, &pObject);
	return pObject;
}

long GetOIDByObj(void *pObject)
{
	return *((dword*)pObject+0x4);
}

void *GetPlayer(dword ObjID)
{
	if(!fixes.bHooked) return NULL;
	if(!pServer) InitConstants();
	return pGetPlayer(pServerExo4, ObjID);
}

//#################### FUNCTIONS ####################

bool CompareVarLists(CNWObjectVarList *pVarList1, CNWObjectVarList *pVarList2)
{
	if(pVarList1->VarCount == 0) return 1;
	for(int i=0; i<pVarList1->VarCount; i++)
	{
		bool bFound = false;
		CNWObjectVarListElement *pVar1 = &pVarList1->VarList[i];
		for(int j=0; j<pVarList2->VarCount; j++)
		{
			CNWObjectVarListElement *pVar2 = &pVarList2->VarList[j];
			if((strcmp(pVar1->sVarName.Text, pVar2->sVarName.Text) == 0) && (pVar1->nVarType == pVar2->nVarType))
			{
				bFound = true;
				//Compare values
				switch(pVar1->nVarType)
				{
				case 1:  //int
					if((int)pVar1->nVarValue != (int)pVar2->nVarValue) return 0;
					break;
				case 2:  //float
					if((float)pVar1->nVarValue != (float)pVar2->nVarValue) return 0;
					break;
				case 3:  //string
					if(strcmp((char *)pVar1->nVarValue, (char *)pVar2->nVarValue) != 0) return 0;
					break;
				case 4:  //object
					if((dword)pVar1->nVarValue != (dword)pVar2->nVarValue) return 0;
					break;
				case 5:  //location
					break;
				}
			}
		}
		if(!bFound) return 0;
	}
}

//#################### HOOKED FUNCTIONS ####################

int GetIsMergeableHookProc(void *pItem1, void *pItem2)
{
	asm ("mov 0xC(%ebp), %eax");
	asm ("push %eax");
	asm ("mov 0x8(%ebp), %eax");
	asm ("push %eax");
	asm ("mov $d_ret_code_merg, %eax");
	asm ("call %eax");
	asm ("add $0x8, %esp");
	asm ("movl %eax, lastRet");
	if(fixes.bHooked && lastRet)
	{
		//Check local vars
		CNWObjectVarList *pVarList1 = (CNWObjectVarList*)((char*)pItem1+0x10+0x4+0xD8);
		CNWObjectVarList *pVarList2 = (CNWObjectVarList*)((char*)pItem2+0x10+0x4+0xD8);
		if(!pVarList1 && !pVarList2) return 1;
		if(!pVarList1 || !pVarList2) return 0;
		return (CompareVarLists(pVarList1, pVarList2) && CompareVarLists(pVarList2, pVarList1));
		//return lastRet;
	}
	else return lastRet;
}

//#################### HOOK ####################

void
d_enable_write (unsigned long location)
{
	char *page;
	page = (char *) location;
	page = (char *) (((int) page + PAGESIZE - 1) & ~(PAGESIZE - 1));
	page -= PAGESIZE;

	if (mprotect (page, PAGESIZE, PROT_WRITE | PROT_READ | PROT_EXEC))
		perror ("mprotect");
}

int intlen = -1;

void
d_redirect (long from, long to, unsigned char *d_ret_code, long len=0)
{
	// enable write to code pages
	d_enable_write (from);
	// copy orig code stub to our "ret_code"
	len = len ? len : sizeof(d_jmp_code)-1; // - trailing 0x00
	intlen = len;
	memcpy ((void *) d_ret_code, (const void *) from, len);
	// make ret code
	*(long *)(d_jmp_code + 1) = from + len;
	memcpy ((char *) d_ret_code + len, (const void *) d_jmp_code, 6);
	// make hook code
	*(long *)(d_jmp_code + 1) = to;
	memcpy ((void *) from, (const void *) d_jmp_code, 6);
}

int FindHookFunctions()
{
	*(dword*)&pGetObjByOID = asmhelp.FindFunctionBySignature("55 89 E5 8B 45 0C 56 53 89 C2 89 C3 C1 E8 1F 0F B7 C0 C1 E0 0C");
	fixes.Log(2, "GetObjByOID: %08lX\n", pGetObjByOID);
	*(dword*)&pGetPlayer = asmhelp.FindFunctionBySignature("55 89 E5 57 56 53 83 EC 0C 8B ** 0C 81 FF 00 00 00 7F");
	fixes.Log(2, "GetPlayer: %08lX\n", pGetPlayer);
	*(dword*)&pGetObjectFactionEntry = asmhelp.FindFunctionBySignature("55 89 E5 ** ** ** A1 ** ** ** ** 8B 40 04 8B 55 08 8B 48 04 8B 82 64 0C 00 00 FF B0 88 00 00 00");
	fixes.Log(2, "GetObjectFactionEntry: %08lX\n", pGetObjectFactionEntry);
	*(dword*)&pGetIsMergeable = asmhelp.FindFunctionBySignature("55 89 E5 57 56 53 83 EC 0C 8B 7D 08 8B 97 E4 01 00 00 85 D2 0F 84 ** ** ** ** 8B 45 0C");
	fixes.Log(2, "GetIsMergeable: %08lX\n", pGetIsMergeable);
	char *pSplitItem_Copy = (char *) asmhelp.FindFunctionBySignature("55 89 E5 57 56 53 83 EC 0C 8B 7D 0C 85 FF 8B 75 08 7E 08 3B BE 84 02 00 00 7C 05");
	fixes.Log(2, "SplitItem_Copy: %08lX\n", pSplitItem_Copy);
	char *pBuyItem = (char *) asmhelp.FindFunctionBySignature("55 89 E5 57 56 53 83 EC 14 8A 45 14 88 45 EF 8B 45 0C FF 70 08 8B 75 08 56 0F B6 7D 18 E8");
	fixes.Log(2, "BuyItem: %08lX\n", pBuyItem);


	if(pSplitItem_Copy)
	{
		d_enable_write((dword) pSplitItem_Copy);
		if(pSplitItem_Copy[0x3F]==0x6A) pSplitItem_Copy[0x40] = 0x1;
		else fixes.Log(2, "Couldn't patch the SplitItem_Copy function\n");
	}

	if(pBuyItem)
	{
		d_enable_write((dword) pBuyItem);
		if(pBuyItem[0x60]==0x6A) pBuyItem[0x61] = 0x1;
		else fixes.Log(2, "Couldn't patch the BuyItem function\n");
	}

	if(pGetIsMergeable) d_redirect((unsigned long)pGetIsMergeable, (unsigned long)GetIsMergeableHookProc, d_ret_code_merg, 9);

	if(!(pGetObjByOID && pGetPlayer))
	{
		fixes.Log(2, "Some of the functions could not be found\n");
		return false;
	}
	fixes.Log(2, "All functions set\n");
	return true;
}

void InitConstants()
{
	if(!pGetIsMergeable) return;
	//Constants
	dword *ppServer = *(dword**)((char *)pGetObjectFactionEntry+0x7);
	//fixes.Log(2, "ppServer=%08lX", ppServer);
	//*(dword*)&ppServer = 0x083281D4;
	*(dword*)&pServer = *ppServer;
	*(dword*)&pRules = *(ppServer+2);
	*(dword*)&p2das = *(dword*)((char*)pRules+0xF0);
	*(dword*)&pServerExo = *(dword*)((char*)pServer+0x4);
	*(dword*)&pServerExo4 = *(dword*)((char*)pServerExo+0x4);


	//��, � ����, � ����������!
	*(dword*)&pObjectClass = *(dword*)(*(dword*)((char*)pServerExo+0x4)+0x10080);
	*(dword*)&pFactionClass = *(dword*)(*(dword*)((char*)pServerExo+0x4)+0x10074);
	*(dword*)&pClientClass = *(dword*)(*(dword*)((char*)pServerExo+0x4)+0x10060);

}


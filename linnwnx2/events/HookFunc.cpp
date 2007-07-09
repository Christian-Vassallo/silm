/***************************************************************************
    Events plugin for NWNX  - hooks implementation
    (c) 2006 virusman (virusman@virusman.ru)

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

#include "HookFunc.h"
#include "NWNXEvents.h"

extern CNWNXEvents events;

void (*pRunScript)();
dword pServThis = 0;
dword pScriptThis = 0;
dword pServerExo = 0;
dword oPC = 0;
dword oTarget_b = OBJECT_INVALID;
dword oItem_b = OBJECT_INVALID;
int bBypass_b;
dword buffer;


char scriptRun = 0;
char ActionScriptRunning = 0;
char ConditionalScriptRunning = 0;


unsigned char d_jmp_code[] = "\x68\x60\x70\x80\x90"       /* push dword 0x90807060 */
                             "\xc3\x90\x90\x90\x90";//x00 /* ret , nop , nop       */

unsigned char d_ret_code_sc[0x20];
unsigned char d_ret_code_pp[0x20];
unsigned char d_ret_code_at[0x20];
unsigned char d_ret_code_ui[0x20];
unsigned char d_ret_code_cn[0x20];
unsigned char d_ret_code_sn[0x20];
unsigned char d_ret_code_cs[0x20];

unsigned char **pEBP;

void SaveCharHookProc()
{
	asm ("pusha");
	if (!scriptRun)
	{
		asm ("add $4, %edi");
		asm ("mov %edi, oPC");
		asm ("sub $4, %edi");
		events.FireEvent(*(dword *)oPC, EVENT_SAVE_CHAR);
	}
	asm ("popa");
	asm ("leave");
	asm ("mov $d_ret_code_sc, %eax");
	asm ("jmp %eax");
}

void PickPocketHookProc()
{
	asm ("pusha");
	if (!scriptRun)
	{
		//Get oPC
		asm ("mov 0x8(%ebp), %eax");
		asm ("add $4, %eax");
		asm ("mov %eax, oPC");

		//Get oTarget
		asm ("mov 0xC(%ebp), %eax");
		asm ("mov %eax, oTarget_b");
		events.oTarget = oTarget_b;
		//asm ("sub $4, %edi");
		events.FireEvent(*(dword *)oPC, EVENT_PICKPOCKET);
	}
	asm ("popa");
	asm ("leave");
	asm ("mov $d_ret_code_pp, %eax");
	asm ("jmp %eax");
}

void AttackHookProc()
{
	asm ("pusha");
	if (!scriptRun)
	{
		//Get oPC
		asm ("mov 0x8(%ebp), %eax");
		asm ("add $4, %eax");
		asm ("mov %eax, oPC");

		//Get oTarget
		asm ("mov 0xC(%ebp), %eax");
		asm ("mov %eax, oTarget_b");
		events.oTarget = oTarget_b;
		//asm ("sub $4, %edi");
		events.FireEvent(*(dword *)oPC, EVENT_ATTACK);
	}
	asm ("popa");
	asm ("leave");
	asm ("mov $d_ret_code_at, %eax");
	asm ("jmp %eax");
}

void UseItemHookProc()
{
	asm ("pusha");
	if (!scriptRun)
	{
		//Get oPC
		asm ("mov 0x8(%ebp), %eax");
		asm ("add $4, %eax");
		asm ("mov %eax, oPC");

		//Get oTarget
		asm ("mov 0x24(%ebp), %eax");
		asm ("mov %eax, oTarget_b");
		events.oTarget = oTarget_b;

		//Get vTarget
		asm ("mov %ebp, %eax");
		asm ("add $0x18, %eax");
		asm ("mov %eax, buffer");
		CNWSVector *pvTarget = (CNWSVector *) buffer;
		events.vPosition.x = pvTarget->x;
		events.vPosition.y = pvTarget->y;
		events.vPosition.z = pvTarget->z;

		//Get oItem
		asm ("mov 0xC(%ebp), %eax");
		asm ("mov %eax, oItem_b");
		events.oItem = oItem_b;

		events.Log(2, "UseItem: oPC=%08lX, oTarget=%08lX, oItem=%08lX, vTarget=%f/%f/%f\n", *(dword *)oPC, events.oTarget, events.oItem, pvTarget->x, pvTarget->y, pvTarget->z);
		bBypass_b = events.FireEvent(*(dword *)oPC, EVENT_USE_ITEM);
	}
	asm ("popa");
	asm ("leave");
	if(bBypass_b)
	{
		asm("mov $1, %eax");
		asm("ret");
	}
	asm ("mov $d_ret_code_ui, %eax");
	asm ("jmp %eax");
}

void ConversationNodeSelectHookProc()
{
	asm ("pusha");
	if (!scriptRun)
	{
		//Get oPC
		asm ("mov %ebp, pEBP");
		CNWSDialogClass *pConversation = *(CNWSDialogClass **)((char *)pEBP+0x8);
		events.pConversation = pConversation;
		oPC = pConversation->ConversationWith;

		//Get oTarget
		events.oTarget = pConversation->MeObjID;

		//Get SelectedNode
		events.nSelectedNodeID = *(dword *)((char *)pEBP+0x14);
		events.nSelectedAbsoluteNodeID = -1;
		try
		{
			dword nCurrentNode = pConversation->CurrentNodeID;
			if(pConversation->EntryListCount > nCurrentNode)
			{
				CDialogEntry *pCurrentNode = &pConversation->EntryList[nCurrentNode];
				if(pCurrentNode->RepliesNum > events.nSelectedNodeID)
				{
					CDialogEntryReply *pCurrentReply = &pCurrentNode->RepliesList[events.nSelectedNodeID];
					events.nSelectedAbsoluteNodeID = pCurrentReply->Index;
				}
			}
		}
		catch(...)
		{
			events.Log(0, "Caught an exception while trying to get absolute node ID\n");
		}

		events.Log(2, "ConversationNodeSelect: oPC=%08lX, oTarget=%08lX, nSelectedNode=%d, nAbsSelectedNode=%d\n", oPC, events.oTarget, events.nSelectedNodeID, events.nSelectedAbsoluteNodeID);
		//events.FireEvent(oPC, EVENT_CONVERSATION_NODE_SELECT);
	}
	asm ("popa");
	//asm ("leave");
	asm ("mov 0x1C(%ebp), %eax");
	asm ("push %eax");
	asm ("mov 0x18(%ebp), %eax");
	asm ("push %eax");
	asm ("mov 0x14(%ebp), %eax");
	asm ("push %eax");
	asm ("mov 0x10(%ebp), %eax");
	asm ("push %eax");
	asm ("mov 0xC(%ebp), %eax");
	asm ("push %eax");
	asm ("mov 0x8(%ebp), %eax");
	asm ("push %eax");

	asm ("mov $d_ret_code_cn, %eax");
	ActionScriptRunning = 1;
	asm ("call %eax");
	asm ("add $0x20, %esp");
	ActionScriptRunning = 0;
}

void ShowEntryNodeHookProc()
{
	asm ("pusha");
	/*
	Nothing.
	Coming in the next version ;)
	*/
	asm ("popa");
	asm ("leave");
	asm ("mov $d_ret_code_sn, %eax");
	asm ("jmp %eax");
}

void ConditionalScriptHookProc()
{
	asm ("pusha");
	if (!scriptRun)
	{
		//Get structures
		asm ("mov %ebp, pEBP");
		CNWSDialogClass *pConversation = *(CNWSDialogClass **)((char *)pEBP+0x8);
		events.pConversation = pConversation;
		dword *pObject = *(dword **)((char *)pEBP+0xC);
		CDialogStartingEntry *pStartingEntry = *(CDialogStartingEntry **)((char *)pEBP+0x10);

		//Absolute index. But what is it? Entry, reply or starting entry?
		dword nNodeID = pStartingEntry->Index;
		events.nCurrentAbsoluteNodeID = nNodeID;

		//Identify node type
		try
		{
			bool bFound = false;
			dword nCurrentNode = pConversation->CurrentNodeID;
			for(int nEntry = 0; nEntry < pConversation->EntryListCount; nEntry++)
			{
				CDialogEntry* pEntry = &pConversation->EntryList[nEntry];
				for(int nReply=0; nReply < pEntry->RepliesNum; nReply++)
				{
					if(&pEntry->RepliesList[nReply] == pStartingEntry)
					{
						events.nNodeType = ReplyNode;
						events.nCurrentNodeID = nReply;
						events.Log(2, "Reply: %d\n", nReply);
						bFound = true;
						break;
					}
				}
				if(bFound == true) break;
			}
			if(bFound == false)
			{
				for(int nReply = 0; nReply < pConversation->ReplyListCount; nReply++)
				{
					CDialogReply* pReply = &pConversation->ReplyList[nReply];
					for(int nEntry=0; nEntry < pReply->EntriesNum; nEntry++)
					{
						if(&pReply->EntriesList[nEntry] == (CDialogReplyEntry *) pStartingEntry)
						{
							events.nNodeType = EntryNode;
							events.nCurrentNodeID = nEntry;
							events.Log(2, "Entry: %d\n", nEntry);
							bFound = true;
							break;
						}
					}
					if(bFound == true) break;
				}
			}
			if(bFound == false)
			{
				for(int nStartingEntry_t = 0; nStartingEntry_t < pConversation->StartingListCount; nStartingEntry_t++)
				{
					if(&pConversation->StartingList[nStartingEntry_t] == pStartingEntry)
					{
						events.nNodeType = StartingNode;
						events.nCurrentNodeID = nStartingEntry_t;
						events.Log(2, "Starting Entry: %d\n", nStartingEntry_t);
						bFound = true;
						break;
					}
				}
			}
			events.Log(2, "ConditionalScript: nNodeID=%d\n", nNodeID);
		}
		catch(...)
		{
			events.Log(0, "Caught an exception while trying to get node type\n");
		}
	}
	asm ("popa");
	//asm ("leave");
	asm ("mov 0x10(%ebp), %eax");
	asm ("push %eax");
	asm ("mov 0xC(%ebp), %eax");
	asm ("push %eax");
	asm ("mov 0x8(%ebp), %eax");
	asm ("push %eax");
	asm ("mov $d_ret_code_cs, %eax");
	ConditionalScriptRunning = 1;
	asm ("call %eax");
	asm ("add $0x10, %esp");
	ConditionalScriptRunning = 0;
}



// finds the address of the SaveChar function
// 0805D68C - SaveChar : 5589E557565381ECB8000000FF7508C78574
// +0x3C - ptr to this_some = this_script_run+8
unsigned long
FindHookSaveChar ()
{
	unsigned long start_addr = 0x08048000, end_addr = 0x08300000;
	char *ptr = (char *) start_addr;

	while (ptr < (char *) end_addr)
	{
		if ((ptr[0] == (char) 0x55) &&
		    (ptr[1] == (char) 0x89) &&
		    (ptr[2] == (char) 0xe5) &&
		    (ptr[3] == (char) 0x57) &&
		    (ptr[4] == (char) 0x56) &&
		    (ptr[5] == (char) 0x53) &&
		    (ptr[6] == (char) 0x81) &&
		    (ptr[7] == (char) 0xec) &&
		    (ptr[8] == (char) 0xb8) &&
		    (ptr[9] == (char) 0x00) &&
		    (ptr[0xA] == (char) 0x00) &&
		    (ptr[0xB] == (char) 0x00) &&
		    (ptr[0xC] == (char) 0xff) &&
		    (ptr[0xD] == (char) 0x75) &&
		    (ptr[0xE] == (char) 0x08) &&
		    (ptr[0xF] == (char) 0xc7) &&
		    (ptr[0x10] == (char) 0x85) &&
		    (ptr[0x11] == (char) 0x74)
		   )
			return (unsigned long) ptr;
		else
			ptr++;
	}
	return 0;
}

//55 89 E5 53 83 EC 10 8B 5D 08 8B 43 0C 53
unsigned long
FindHookPickPocket ()
{
	unsigned long start_addr = 0x08048000, end_addr = 0x08300000;
	char *ptr = (char *) start_addr;

	while (ptr < (char *) end_addr)
	{
		if ((ptr[0] == (char) 0x55) &&
		    (ptr[1] == (char) 0x89) &&
		    (ptr[2] == (char) 0xe5) &&
		    (ptr[3] == (char) 0x53) &&
		    (ptr[4] == (char) 0x83) &&
		    (ptr[5] == (char) 0xec) &&
		    (ptr[6] == (char) 0x10) &&
		    (ptr[7] == (char) 0x8b) &&
		    (ptr[8] == (char) 0x5d) &&
		    (ptr[9] == (char) 0x08) &&
		    (ptr[0xA] == (char) 0x8b) &&
		    (ptr[0xB] == (char) 0x43) &&
		    (ptr[0xC] == (char) 0x0c) &&
		    (ptr[0xD] == (char) 0x53)
		   )
			return (unsigned long) ptr;
		else
			ptr++;
	}
	return 0;
}

//55 89 E5 57 56 53 83 EC 18 8B 7D 08
unsigned long
FindHookAttack ()
{
	unsigned long start_addr = 0x08048000, end_addr = 0x08300000;
	char *ptr = (char *) start_addr;

	while (ptr < (char *) end_addr)
	{
		if ((ptr[0] == (char) 0x55) &&
		    (ptr[1] == (char) 0x89) &&
		    (ptr[2] == (char) 0xe5) &&
		    (ptr[3] == (char) 0x57) &&
		    (ptr[4] == (char) 0x56) &&
		    (ptr[5] == (char) 0x53) &&
		    (ptr[6] == (char) 0x83) &&
		    (ptr[7] == (char) 0xEC) &&
		    (ptr[8] == (char) 0x18) &&
		    (ptr[9] == (char) 0x8B) &&
		    (ptr[0xA] == (char) 0x7D) &&
		    (ptr[0xB] == (char) 0x08) &&
		    (ptr[0xC] == (char) 0x57) &&
		    (ptr[0xD] == (char) 0xE8) &&
		    //0xE
		    //0xF
		    //0x10
		    //0x11
		    (ptr[0x12] == (char) 0x83) &&
		    (ptr[0x13] == (char) 0xC4) &&
		    (ptr[0x14] == (char) 0x10) &&
		    (ptr[0x15] == (char) 0xFF) &&
		    (ptr[0x16] == (char) 0x75) &&
		    (ptr[0x17] == (char) 0x0C)
		   )
			return (unsigned long) ptr;
		else
			ptr++;
	}
	return 0;
}

/*
.text:081131F0 55                      push    ebp
.text:081131F1 89 E5                   mov     ebp, esp
.text:081131F3 57                      push    edi
.text:081131F4 56                      push    esi
.text:081131F5 53                      push    ebx
.text:081131F6 81 EC F4 00 00 00       sub     esp, 0F4h
.text:081131FC FF 75 0C                push    [ebp+nItemObjID]
*/
unsigned long
FindHookUseItem ()
{
	unsigned long start_addr = 0x08048000, end_addr = 0x08300000;
	char *ptr = (char *) start_addr;

	while (ptr < (char *) end_addr)
	{
		if ((ptr[0] == (char) 0x55) &&
		    (ptr[1] == (char) 0x89) &&
		    (ptr[2] == (char) 0xe5) &&
		    (ptr[3] == (char) 0x57) &&
		    (ptr[4] == (char) 0x56) &&
		    (ptr[5] == (char) 0x53) &&
		    (ptr[6] == (char) 0x81) &&
		    (ptr[7] == (char) 0xec) &&
		    (ptr[8] == (char) 0xf4) &&
		    (ptr[9] == (char) 0x00) &&
		    (ptr[0xA] == (char) 0x00) &&
		    (ptr[0xB] == (char) 0x00) &&
		    (ptr[0xC] == (char) 0xff) &&
		    (ptr[0xD] == (char) 0x75) &&
		    (ptr[0xE] == (char) 0x0c)
		   )
			return (unsigned long) ptr;
		else
			ptr++;
	}
	return 0;
}

/*
.text:08238B50 55                      push    ebp
.text:08238B51 89 E5                   mov     ebp, esp
.text:08238B53 57                      push    edi
.text:08238B54 56                      push    esi
.text:08238B55 53                      push    ebx
.text:08238B56 81 EC AC 00 00 00       sub     esp, 0ACh
.text:08238B5C 8B 75 18                mov     esi, [ebp+arg_10]
.text:08238B5F 85 F6                   test    esi, esi
.text:08238B61 8B 7D 08                mov     edi, [ebp+pConversation]
*/

unsigned long
FindHookConversationNodeSelect ()
{
	unsigned long start_addr = 0x08048000, end_addr = 0x08300000;
	char *ptr = (char *) start_addr;

	while (ptr < (char *) end_addr)
	{
		if ((ptr[0] == (char) 0x55) &&
		    (ptr[1] == (char) 0x89) &&
		    (ptr[2] == (char) 0xe5) &&
		    (ptr[3] == (char) 0x57) &&
		    (ptr[4] == (char) 0x56) &&
		    (ptr[5] == (char) 0x53) &&
		    (ptr[6] == (char) 0x81) &&
		    (ptr[7] == (char) 0xec) &&
		    (ptr[8] == (char) 0xac) &&
		    (ptr[9] == (char) 0x00) &&
		    (ptr[0xA] == (char) 0x00) &&
		    (ptr[0xB] == (char) 0x00) &&
		    (ptr[0xC] == (char) 0x8b) &&
		    (ptr[0xD] == (char) 0x75) &&
		    (ptr[0xE] == (char) 0x18) &&
		    (ptr[0xF] == (char) 0x85) &&
		    (ptr[0x10] == (char) 0xf6) &&
		    (ptr[0x11] == (char) 0x8b) &&
		    (ptr[0x12] == (char) 0x7d) &&
		    (ptr[0x13] == (char) 0x08)
		   )
			return (unsigned long) ptr;
		else
			ptr++;
	}
	return 0;
}

unsigned long
FindHookShowEntryNode ()
{
	unsigned long start_addr = 0x08048000, end_addr = 0x08300000;
	char *ptr = (char *) start_addr;

	while (ptr < (char *) end_addr)
	{
		if ((ptr[0] == (char) 0x55) &&
		    (ptr[1] == (char) 0x89) &&
		    (ptr[2] == (char) 0xe5) &&
		    (ptr[3] == (char) 0x56) &&
		    (ptr[4] == (char) 0x53) &&
		    (ptr[5] == (char) 0x83) &&
		    (ptr[6] == (char) 0xec) &&
		    (ptr[7] == (char) 0x10) &&
		    (ptr[8] == (char) 0x8b) &&
		    (ptr[9] == (char) 0x5d) &&
		    (ptr[0xA] == (char) 0x08) &&
		    (ptr[0xB] == (char) 0x8b) &&
		    (ptr[0xC] == (char) 0x53) &&
		    (ptr[0xD] == (char) 0x40) &&
		    (ptr[0xE] == (char) 0x85) &&
		    (ptr[0xF] == (char) 0xd2)
		   )
			return (unsigned long) ptr;
		else
			ptr++;
	}
	return 0;
}

unsigned long
FindHookConditionalScript ()
{
	unsigned long start_addr = 0x08048000, end_addr = 0x08300000;
	char *ptr = (char *) start_addr;

	while (ptr < (char *) end_addr)
	{
		if ((ptr[0] == (char) 0x55) &&
		    (ptr[1] == (char) 0x89) &&
		    (ptr[2] == (char) 0xe5) &&
		    (ptr[3] == (char) 0x56) &&
		    (ptr[4] == (char) 0x53) &&
		    (ptr[5] == (char) 0x83) &&
		    (ptr[6] == (char) 0xec) &&
		    (ptr[7] == (char) 0x28) &&

		    (ptr[0xD] == (char) 0x8B) &&
		    (ptr[0xE] == (char) 0x75) &&
		    (ptr[0xF] == (char) 0x10) &&
		    (ptr[0x10] == (char) 0x56)
		   )
			return (unsigned long) ptr;
		else
			ptr++;
	}
	return 0;
}

// 0824AA5C - runScript : 55 89 e5 57 56 53 83 ec 18 ff 75 0c e8 eb
unsigned long
FindHookRunScript()
{
	unsigned long start_addr = 0x08048000, end_addr = 0x08300000;
	char *ptr = (char *) start_addr;

	while (ptr < (char *) end_addr)
	{
		if ((ptr[0] == (char) 0x55) &&
		    (ptr[1] == (char) 0x89) &&
		    (ptr[2] == (char) 0xe5) &&
		    (ptr[3] == (char) 0x57) &&
		    (ptr[4] == (char) 0x56) &&
		    (ptr[5] == (char) 0x53) &&
		    (ptr[6] == (char) 0x83) &&
		    (ptr[7] == (char) 0xec) &&
		    (ptr[8] == (char) 0x18) &&
		    (ptr[9] == (char) 0xFF) &&
		    (ptr[10] == (char) 0x75) &&
		    (ptr[11] == (char) 0x0C) &&
		    (ptr[12] == (char) 0xE8) &&
		    (ptr[0x3B] == (char) 0x84) &&
		    (ptr[0x3C] == (char) 0x01) &&
		    (ptr[0x3D] == (char) 0x00)
		   )
			return (unsigned long) ptr;
		else
			ptr++;
	}
	return 0;
}

// grr...
int sptr[4];
char * gsname;
int gObjID;

void RunScript(char * sname, int ObjID)
{
	gsname = sname;
	gObjID = ObjID;
	sptr[1] = strlen(sname);
	asm("movl $sptr, %edx");
	asm("movl gsname, %eax");
	asm("mov %eax, (%edx)");
	asm("push $1");
	asm("push gObjID");
	asm("push %edx");
	asm("movl pScriptThis, %ecx");
	asm("mov (%ecx), %ecx");
	asm("push %ecx");
	scriptRun = 1;
	pRunScript();
	scriptRun = 0;
}

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

int HookFunctions()
{
	dword org_SaveChar = FindHookSaveChar();
	dword org_Run = FindHookRunScript();
	dword org_PickPocket = FindHookPickPocket();
	dword org_Attack = FindHookAttack();
	dword org_UseItem = FindHookUseItem();
	dword org_ConvSelect = FindHookConversationNodeSelect();
	dword org_ConvShow = FindHookShowEntryNode();
	dword org_ConditionalScript = FindHookConditionalScript();
	if (org_SaveChar)
	{
		pServThis = *(dword*)(org_SaveChar + 0x3C);
		pScriptThis = pServThis - 8;
		//pServerExo = *(dword*)pServThis+0x4;
		d_redirect (org_SaveChar, (unsigned long)SaveCharHookProc, d_ret_code_sc, 12);
	}
	if (org_PickPocket)
	{
		d_redirect (org_PickPocket, (unsigned long)PickPocketHookProc, d_ret_code_pp, 10);
	}
	if (org_Attack)
	{
		d_redirect (org_Attack, (unsigned long)AttackHookProc, d_ret_code_at, 9);
	}
	if (org_UseItem)
	{
		d_redirect (org_UseItem, (unsigned long)UseItemHookProc, d_ret_code_ui, 12);
	}
	if (org_ConvSelect)
	{
		d_redirect (org_ConvSelect, (unsigned long)ConversationNodeSelectHookProc, d_ret_code_cn, 12);
	}
	if (org_ConvShow)
	{
		d_redirect (org_ConvShow, (unsigned long)ShowEntryNodeHookProc, d_ret_code_sn, 8);
	}
	if (org_ConditionalScript)
	{
		d_redirect (org_ConditionalScript, (unsigned long)ConditionalScriptHookProc, d_ret_code_cs, 8);
	}


	if (org_Run) {
		*(dword*)&pRunScript = org_Run;
	}

	if (org_SaveChar)
		events.Log(0, "! SaveChar hooked at %x.\n", org_SaveChar);
	else
		events.Log(0, "X Could not find SaveChar function or hook failed: %x\n", org_SaveChar);

	if (org_PickPocket)
		events.Log(0, "! ActPickPocket hooked at %x.\n", org_PickPocket);
	else
		events.Log(0, "X Could not find ActPickPocket function or hook failed: %x\n", org_PickPocket);

	if (org_Attack)
		events.Log(0, "! ActAttack hooked at %x.\n", org_Attack);
	else
		events.Log(0, "X Could not find ActAttack function or hook failed: %x\n", org_Attack);

	if (org_UseItem)
		events.Log(0, "! UseItem hooked at %x.\n", org_UseItem);
	else
		events.Log(0, "X Could not find UseItem function or hook failed: %x\n", org_UseItem);

	if (org_ConvSelect)
		events.Log(0, "! ConversationNodeSelect hooked at %x.\n", org_ConvSelect);
	else
		events.Log(0, "X Could not find ConversationNodeSelect function or hook failed: %x\n", org_ConvSelect);

	if (org_ConvShow)
		events.Log(0, "! ShowEntryNode hooked at %x.\n", org_ConvShow);
	else
		events.Log(0, "X Could not find ShowEntryNode function or hook failed: %x\n", org_ConvShow);

	if (org_ConditionalScript)
		events.Log(0, "! ConditionalScript hooked at %x.\n", org_ConditionalScript);
	else
		events.Log(0, "X Could not find ConditionalScript function or hook failed: %x\n", org_ConditionalScript);



	if (org_Run)
		events.Log(0, "! RunProc located at %x.\n", org_Run);
	else
		events.Log(0, "X Could not find Run function: %x\n", org_Run);

	return (org_SaveChar && org_PickPocket && org_Attack && org_UseItem &&
	        org_ConvSelect && org_ConvShow && org_ConditionalScript && org_Run && pServThis && pScriptThis);
}



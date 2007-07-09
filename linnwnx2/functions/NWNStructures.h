#include "typedefs.h"

#ifndef NWNXStructures_h_
#define NWNXStructures_h_

/*
00000000 CNWSAmbientSoundClass struc ; (sizeof=0x2C)
00000000 Enabled         dd ?
00000004 MusicDelay      dd ?
00000008 MusicDay        dd ?
0000000C MusicNight      dd ?
00000010 field_10        dd ?
00000014 MusicBattle     dd ?
00000018 field_18        dd ?
0000001C AmbientSndDay   dd ?
00000020 AmbientSndNight dd ?
00000024 AmbientSndDayVol db ?
00000025 AmbientSndNitVol db ?
00000026 field_26        db ?
00000027 field_27        db ?
00000028 CNWSAmbientSound dd ?                   ; offset
0000002C CNWSAmbientSoundClass ends
*/

struct CNWSAmbientSound
{
	dword Enabled;
	dword MusicDelay;
	dword MusicDay;
	dword MusicNight;
	dword field_10;
	dword MusicBattle;
	dword field_18;
	dword AmbientSndDay;
	dword AmbientSndNight;
	byte  AmbientSndDayVol;
	byte  AmbientSndNitVol;
	byte  field_26;
	byte  field_27;
	void *CNWSAmbientSoundClass;
};

struct CExoString
{
	char *Text;
	dword Length;
};

struct AddressStruct
{
	word unk;		//0x0 
	word port;		//0x2
	dword ip;		//0x4
	dword unk2;		//0x8
	dword unk3;		//0xC
}; //total 0x10

#endif

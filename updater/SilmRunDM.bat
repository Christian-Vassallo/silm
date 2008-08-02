@echo off
setlocal
set /P dmpass="DM Password? "

echo Updating ourselves. :)
rsync\rsync.exe -Rvz --progress -c rsync://miyeritar.swordcoast.net/nwn/SilmRunDM.bat .
if errorlevel 1 (
	echo "Fehler bei Uebertragung. Bitte lies die obige Fehlermeldung."
	pause
	exit
)

echo Updating haks ..
rsync\rsync.exe -rRvz --progress --size-only rsync://miyeritar.swordcoast.net/nwn/hak/ .
if errorlevel 1 (
	echo "Fehler bei Uebertragung. Bitte lies die obige Fehlermeldung."
	pause
	exit
)

echo Updating tlks ..
rsync\rsync.exe -rRvz --progress --size-only rsync://miyeritar.swordcoast.net/nwn/tlk/ .
if errorlevel 1 (
	echo "Fehler bei Uebertragung. Bitte lies die obige Fehlermeldung."
	pause
	exit
)

echo Updating portraits ..
rsync\rsync.exe -rRvz --progress --size-only rsync://miyeritar.swordcoast.net/nwn/portraits/ .
if errorlevel 1 (
	echo "Fehler bei Uebertragung. Bitte lies die obige Fehlermeldung."
	pause
	exit
)

echo All done, starting NWN for you 
start /WAIT nwmain.exe -dmc +connect miyeritar.swordcoast.net:5121 +password %dmpass%

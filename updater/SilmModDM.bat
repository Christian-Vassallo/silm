@echo off

setlocal

set PATH=%PATH%;rsync

set USER=user
set RSYNC_PASSWORD=pass

rsync.exe -Rvz --progress %user%@miyeritar.swordcoast.net::nwn-u/Silbermarken.mod modules
if errorlevel 1 (
	echo "Fehler bei Uebertragung. Bitte lies die obige Fehlermeldung."
)

pause

@echo off

echo Warnung - dies ueberschreibt ein eventuell vorhandendes Leermodul.
echo Wenn du dir nicht sicher bist, das dies geschen soll, so druecke
echo JETZT JETZT JETZT
echo  Steuerung + C

pause

rsync\rsync.exe -Rvz --progress rsync://miyeritar.swordcoast.net/nwn/modules/ .
if errorlevel 1 (
	echo "Fehler bei Uebertragung. Bitte lies die obige Fehlermeldung."
	pause
	exit
)

echo All done
echo Du kannst das Leermodul nun im Toolset oeffnen.

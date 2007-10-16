@echo off

if not exist nwmain.exe (
  echo Du befindest dich hier nicht im NWN-Verzeichnis.
  echo Bitte rufe mich im NWN-Verzeichnis auf.
  echo Taste druecken zum Beenden.
  pause
  exit
)

setlocal

set PATH=%PATH%;rsync

set portraits=j
set self=j
set tlks=j
set haks=j

if not exist silmsettings.bat (
  echo Dies scheint das erste Mal zu sein, dass du den Silbermarken-Updater startest.
  echo Beantworte bitte die folgenden Fragen mit j/n fuer Ja/Nein.
  
  :askport
  set /P portraits=" Soll ich automatisch alle Spieler-Portraits herunterladen? [j/n]? "
  if not "%portraits%" == "j" (
    if not "%portraits%" == "n" (
      goto :askport
    )
  )
  
  echo set init=j > silmsettings.bat
  echo set self=j >> silmsettings.bat
  echo set portraits=%portraits% >> silmsettings.bat
  echo set tlks=j >> silmsettings.bat
  echo set haks=j >> silmsettings.bat
  echo Einstellungen nach silmsettings.bat gesichert.
) else (
  call silmsettings.bat
  echo Einstellungen laden.
)


if %self% == j (
  echo Updating ourselves ..
  rsync.exe -Rvz --progress -c rsync://miyeritar.swordcoast.net/nwn/SilmUpdate.bat .
  if errorlevel 1 (
    echo "Fehler bei Uebertragung. Bitte lies die obige Fehlermeldung."
    pause
    exit
  )
) else (
  echo Lade keinen aktuellen Updater herunter, da so bei Konfiguration angegeben.
)

if %portraits% == j (
  echo Updating portraits ..
  rsync.exe -rRvz --progress --size-only rsync://miyeritar.swordcoast.net/nwn/portraits/ .
  if errorlevel 1 (
    echo Fehler bei Uebertragung. Bitte lies die obige Fehlermeldung.
    pause
    exit
  )
) ELSE (
  echo Lade keine Portraits herunter, da so bei Konfiguration angegeben.
)

if %tlks% == j (
  echo Updating tlks ..
  rsync.exe -rRvz --progress --size-only rsync://miyeritar.swordcoast.net/nwn/tlk/ .
  if errorlevel 1 (
    echo "Fehler bei Uebertragung. Bitte lies die obige Fehlermeldung."
    pause
    exit
  )
) else (
  echo Lade keine tlks herunter, da so bei Konfiguration angegeben.
)

if %haks% == j (
  echo Updating haks ..
  rsync.exe -rRvz --progress --size-only rsync://miyeritar.swordcoast.net/nwn/hak/ .
  if errorlevel 1 (
    echo "Fehler bei Uebertragung. Bitte lies die obige Fehlermeldung."
    pause
    exit
  )
) else (
  echo Lade keine haks herunter, da so bei Konfiguration angegeben.
)


echo Fertig, starte NWN
start /WAIT nwmain.exe +connect miyeritar.swordcoast.net:5121

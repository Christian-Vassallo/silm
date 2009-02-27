#!/bin/sh

AREAS=$(ls area/*.are.yml | wc -l)
SCRIPTS=$(ls nss/*.n | wc -l)
UTI=$(ls uti/*.uti.yml | wc -l)
UTC=$(ls utc/*.utc.yml | wc -l)
DLG=$(ls dlg/*.dlg.yml | wc -l)

SCRIPTLINES=$(wc -l nss/*.n | grep total | cut -d" " -f3)
DIALOGUECHARS=$(egrep "^ +4:" dlg/*.dlg.yml | wc -c)
REPOSIZE=$(du -sch .|grep total | cut -f1)

REV=`git rev-parse --short --verify HEAD`

printf "Statistics for commit %s, created on\n" $REV
printf "  %s\n" "$(date)"
printf "%-20s: %s\n" "Areas" $AREAS
printf "%-20s: %s\n" "Scripts" $SCRIPTS
printf "%-20s: %s\n" "Item templates" $UTI
printf "%-20s: %s\n" "Creature templates" $UTC
printf "%-20s: %s\n" "Dialogue templates" $DLG
printf "\n"

printf "%-20s: %s\n" "Lines of Script" $SCRIPTLINES
printf "%-20s: %s\n" "Letters of Dialogue" $DIALOGUECHARS

printf "%-20s: %s\n" "Repository size" $REPOSIZE

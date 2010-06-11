#!/usr/bin/env nwn-dsl

$gff = need ARGV.shift, :git
count = 0

($gff / 'Placeable List').v.each {|pp|
  next unless pp / 'Tag$' == "Barrikade"
  pp['Useable'].v = 0
  pp['Static'].v = 1
  count += 1
}

log "Fixed #{count} Barricades"

save $gff, true

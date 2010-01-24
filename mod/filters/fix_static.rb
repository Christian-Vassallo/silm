#!/usr/bin/env nwn-dsl

want :git

count = 0

(self / 'Placeable List$').each {|item|
  if (item / 'Useable$') == 0 && (item / 'Static$') == 0
    (item / 'Static').v = 1
    count += 1
  end
}

log "#{count} placeables made static."

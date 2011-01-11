#!/usr/bin/env nwn-dsl

want :git

count = 0
pvq = 0

(self / 'Placeable List$').each {|item|
  case (item / 'TemplateResRef$')
    # hotfix: project q placeables use shinytextures that
    # don't do proper transparency when static. force non-static.
    when /^pvq_/
      (item / 'Static').v = 0
      pvq += 1
    else
      if (item / 'Useable$') == 0 && (item / 'Static$') == 0
        (item / 'Static').v = 1
        count += 1
      end
  end
}

log "#{count} placeables made static."
log "#{pvq} placeables forced non-static."

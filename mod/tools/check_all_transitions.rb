#!/usr/bin/env nwn-dsl

# Works as follows:

# load all given areas, with all triggers
# store target waypoint tags
# store all local waypoint tags

# All known AT triggers.
# at-tag -> wp-tag
$AT = {}

# All known waypoints.
# wp-tag -> filename
$WP = {}

for file in ARGV
#  log "Loading #{file} .."
  area_gff = Gff.read(IO.read(file), Gff.guess_file_format(file))

  area_gff['WaypointList'].v.each {|wp|
    next if wp['TemplateResRef'].v != ""
    tag = wp['Tag'].v

    $WP[tag] ||= []
    $WP[tag] << file
  }

  area_gff['TriggerList'].v.each {|at|
    next unless at['LinkedTo'] && at['LinkedTo'].v != ""

    tag = at['Tag'].v
    linked_to = at['LinkedTo'].v

    if $AT[tag]
      log "#{file}: Warning: Duplicate AT tag #{tag.inspect} in #{$AT[tag][1]}"

    else
      $AT[tag] = [linked_to, file]
    end
  }
end

log ""

$WP.each {|tag, f_a|
  if f_a.size > 1
    log "WP #{tag.inspect} dupes in: #{f_a.inspect}"
  end
}

log ""

# Now check that all registered ATs have a waypoint
$AT.each {|tag, (linked_to, file)|
  if $WP.key?(linked_to)
    # log "#{file}: found target in area #{$WP[linked_to]}"

  else
    log "#{file}: WP missing: #{tag} -> #{linked_to}"

  end
}

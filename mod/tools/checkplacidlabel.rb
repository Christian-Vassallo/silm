#!/usr/bin/nwn-dsl -b
# vim: ft=ruby

# checks Label names vs placeable IDs to automagically fix
# ID row changes in hak updates. Check results before committing.

$twoda = TwoDA.get('placeables')

$placeables = {}

pdir = ARGV.shift
utp = Dir[File.expand_path(pdir) + "/*.utp.yml"]
utp.each_with_index {|placeable, idx|
  plac = need placeable, :utp
  id, locname = plac['Appearance'].v, plac['LocName'].v[0]
  $placeables[id] = locname
  progress idx, utp.size
}

log "indexed #{$placeables.size} placies"

ARGV.each_with_index {|file, idx|
  git = need file, :git

  git['Placeable List'].v.each {|placeable|
    next unless placeable['LocName']
    fail unless placeable['Appearance']

    locname = placeable['LocName'].v[0]
    id = placeable['Appearance'].v.to_i
    label = $twoda[id.to_i].Label

    if label == ""
      log "#{file}: Invalid placeable: #{id}"
      next
    end

    # No locname set, can't match that one onto anything ..
    next unless locname

    # Label matches the locname, this gotta be a direct match
    next if label == locname

    # See if we have the matching id in the table already
    real_id = $twoda.by_col('Label').index(locname)

    if !real_id
      # Find all placeables which are named after this placed one
      matching_placeables = $placeables.select {|k,v| v == locname }.map{|x| x[0] }

      # if one of those has the current id we dont need to do anything
      next if matching_placeables.index(id)

      if matching_placeables.size > 1
        log "More IDs than one found: #{matching_placeables.inspect}"
        matching_placeables.each {|rid|
          log "  %d: twoda=%s locname=%s model=%s" % [rid, $twoda[rid].Label, locname, $twoda[rid].ModelName]
        }
        log "Selecting the first one"
      end
      matching_placeables = matching_placeables[0]

      real_id = matching_placeables
    end

    # A placeable with a modified name, can't match that
    next unless real_id

    if real_id != id
      log "#{id}: #{label.inspect} vs #{locname.inspect}, real id: #{real_id}"
      placeable['Appearance'].v = real_id
    end
  }

  progress idx
  save git
}

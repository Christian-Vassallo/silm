remove = %w{w_a area_marker}

for f in ARGV do
  g = need f, :git
  wl = g / 'WaypointList$'
  wl.each {|w|
    tag = w / 'Tag$'
    if remove.index(tag)
      log "Removed #{tag}"
      wl.delete(w)
    end
  }
  save g
end

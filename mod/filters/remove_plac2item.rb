want :git

self['Placeable List'].v.each {|p|
  if p / 'OnMeleeAttacked$' == "plac2item"
    log "Unsetting plac2item on #{p / 'Tag$'}"
    p['OnMeleeAttacked'].v = ""
  end
}

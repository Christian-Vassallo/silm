#!/usr/bin/env nwn-dsl

ARGV.each_with_index {|are, idx|
  are = need are, :are

  ref, tag = are['ResRef'].v, are['Tag'].v


  log "%-16s = %s" % [ref, tag]

  if ref != tag
    tag = are['Tag'].v = ref.downcase
    log " .. tag fixed."
  end

  save are

  progress idx
}

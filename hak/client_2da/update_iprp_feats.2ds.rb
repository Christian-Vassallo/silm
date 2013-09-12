#!/usr/bin/env nwn-dsl

feats = TwoDA::Table.parse(IO.read("feat.2ds"))
iprp  = TwoDA::Table.parse(IO.read("iprp_feats.2ds"))
iprpn = TwoDA::Table.parse(IO.read("iprp_feats.2ds"))

newrows = 0

feats.rows.each_with_index do |feat, featidx|
  iprp_row = iprp.rows.select {|row| row.FeatIndex.to_i == featidx }[0]
  next if iprp_row
  next if feat.FEAT == "" || feat.FEAT.nil? || feat.FEAT == "***"
  
  newrows += 1
  #fail "not added: #{feat.inspect}"
  # Name, Label, Cost, FeatIndex
  iprpn.rows << [feat.FEAT, feat.LABEL, "1", featidx.to_s]
end

puts iprpn.to_2da

if newrows > 0
  log "#{newrows} new spell rows"
  log "*******************"
  log " add to repository"
  log "*******************"
end

#!/usr/bin/env nwn-dsl

app = IO.read(ARGV.shift)
appearance = TwoDA::Table.parse(app)
tailmodel  = TwoDA::Table.read_from($stdin)

app_start  = 7

already_tailmodel = tailmodel.rows.map {|row| row.MODEL.downcase }

newmodels = 0
appearance.rows[app_start .. -1].each {|x|
  next if x.RACE == ""

  next if already_tailmodel.index(x.RACE.downcase)

  newmodels += 1
  tailmodel.rows << [ x.LABEL, x.RACE, x.ENVMAP ]
}

puts tailmodel.to_2da

if newmodels > 0
  log "#{newmodels} new models"
  log "*******************"
  log " add to repository"
  log "*******************"
end

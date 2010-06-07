#!/usr/bin/env nwn-dsl

spells = TwoDA::Table.parse(IO.read("spells.2ds"))
des = TwoDA::Table.parse(IO.read("des_crft_spells.2ds"))
iprp = TwoDA::Table.parse(IO.read("iprp_spells.2ds"))

start = des.rows.size
newrows = 0

for idx in start...spells.rows.size
  row = spells.rows[idx]
  iprp_row = iprp.rows.select {|row| row.SpellIndex.to_i == idx }[0]

  ip_id = if iprp_row then iprp_row.ID else "" end
  lvl = if iprp_row then iprp_row.InnateLvl else "" end
  pot = if iprp_row then iprp_row.PotionUse else "0" end
  wand = if iprp_row then iprp_row.WandUse else "0" end
  scroll = if iprp_row then iprp_row.GeneralUse else "0" end
  pot = if pot == "1" then "0" else "1" end
  wand = if pot == "1" then "0" else "1" end
  scroll = if pot == "1" then "0" else "1" end
  # Label, IPRP Index, NoPotion, NoWand, NoScroll, Level, CastOnItems
  des.rows << [spells.rows[idx].Label, ip_id.to_s, pot, wand, scroll, lvl, "0"]
end

puts des.to_2da

if newrows > 0
  log "#{newrows} new spell rows"
  log "*******************"
  log " add to repository"
  log "*******************"
end

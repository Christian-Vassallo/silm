#!/usr/bin/env nwn-dsl

app = TwoDA::Cache.get('appearance')
mask = "#define APPEARANCE_TYPE_%s %d"

app.rows.each do |row|
  next if row.LABEL == ""
  item = row.LABEL.upcase.gsub(/[^A-Z0-9,]/, "_").gsub(/_{2,}/, "_").gsub(/_$/, "").gsub(",", "_")
  puts mask % [item, row.ID]
end

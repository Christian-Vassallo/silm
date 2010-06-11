#!/usr/bin/env nwn-dsl

$gff = need ARGV.shift, :git

($gff / 'Placeable List$').each do |pv|
  next unless pv / 'Useable$' == 1
  puts "%s: %s" % [pv / 'Tag$', pv / 'LocName/0']
end

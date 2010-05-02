#!/usr/bin/env nwn-dsl

$ifo = need ARGV.shift, :ifo

for x in $ifo / 'Mod_HakList$'
  puts x / 'Mod_Hak$'
end

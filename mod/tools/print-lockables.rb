#!/usr/bin/env nwn-dsl

$gff = need ARGV.shift, :git

($gff / 'Door List$').each do |pv|
  next unless pv / 'Lockable$' == 1
  puts "%s: locked=%d opendc=%d closedc=%d req=%d key=%s" % [pv / 'Tag$',
    pv / 'Locked$', pv / 'OpenLocDC$', pv / 'CloseLockDC$', pv / 'KeyRequired$',
    pv / 'KeyName$']
end

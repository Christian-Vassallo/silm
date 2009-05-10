# vim: ft=ruby


want :are

self['OnEnter'].v = "sr_enter_" + ask("Enter Script:",
  %w{arctic cave desert forest hills inside outside}) if "" == self['OnEnter'].v

# 0x01 interior
# 0x02 underground
# 0x04 natural

case self['OnEnter'].v
  when 'sr_enter_inside'
    if self['Flags'].v & 0x01 == 0
      log "Forcing area to be flagged as interor."
      self['Flags'].v |= 0x01
    end

  when 'sr_enter_cave'
    if self['Flags'].v & 0x03 == 0
      log "Forcing area to be flagged as interior and underground."
      self['Flags'].v |= 0x03
    end

  when /^sr_enter_(forest|hills|outside|desert)$/
    fail "area flagged as interior, but outside script assigned. investigate." if
      self['Flags'].v & 0x01 > 0
end

self['OnExit'].v = "_area_leave"
self['OnHeartbeat'].v = "_area_hb"
self['OnUserDefined'].v = "_area_udef"

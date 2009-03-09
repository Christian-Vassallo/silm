# vim: ft=ruby


want :are

self['OnEnter'].v = "sr_enter_" + ask("Enter Script:",
  %w{arctic cave desert forest hills inside outside}) if "" == self['OnEnter'].v

self['OnExit'].v = "_area_leave"
self['OnHeartbeat'].v = "_area_hb"
self['OnUserDefined'].v = "_area_udef"

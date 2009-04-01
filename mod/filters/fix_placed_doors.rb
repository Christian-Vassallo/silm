# vim: ft=ruby
# This script fixes all door scripts in a git.yml template. Do not
# call it with anything else as a parameter.

$scripts = {
  'OnClick' => 'door_click',
  'OnClosed' => 'door_closed',
  'OnDamaged' => 'door_damaged',
  'OnDisarm' => 'door_disarm',
  'OnDeath' => 'door_death',
  'OnFailToOpen' => 'door_failtoopen',
  'OnHeartbeat' => '',
  'OnMeleeAttacked' => 'door_attacked',
  'OnLock' => 'door_lock',
  'OnOpen' => 'door_open',
  'OnSpellCastAt' => 'door_spellcast',
  'OnTrapTriggered' => 'door_traptrig',
  'OnUnlock' => 'door_unlock',
  'OnUserDefined' => '',
}

want :git

# log "#{git['Door List'].v.size} doors placed."

self['Door List'].v.each {|door|
  scripts = []
  $scripts.each {|n,desired_value|
    v = door[n].v
    if v != '' && v != desired_value && (n == 'OnDeath' && v != 'x2_door_death')
      scripts << "#{n}=#{v}"

    else
      if v != desired_value
        changed = true
        door[n].v = desired_value #  = NWN::Gff::Element.new(n, :resref, desired_value)
      end
    end
  }

  log scripts.join(" ") if scripts.size > 0
}

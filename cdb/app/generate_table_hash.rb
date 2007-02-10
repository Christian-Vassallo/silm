#!/usr/bin/ruby -w

inf = $stdin.read
indent = ARGV.shift.to_i

spells = {}
feats = {}
skills = {}
abilities = {}

inf.each_line do |l|
	l.strip!
	case l
		when /^int\s+(SPELL_\S+)\s+=\s+(\d+);$/
			spells[$1] = $2.to_i;
		when /^int\s+(FEAT_\S+)\s+=\s+(\d+);$/
			feats[$1] = $2.to_i;
		when /^int\s+(SKILL_\S+)\s+=\s+(\d+);$/
			skills[$1] = $2.to_i;
		when /^int\s+(ABILITY_\S+)\s+=\s+(\d+);$/
			abilities[$1] = $2.to_i;
	end
end

spells["none"] = -1
skills["none"] = -1
feats["none"] = -1
abilities["none"] = -1

print "SPELLS = "; p spells
print "FEATS = "; p feats
print "SKILLS = "; p skills
print "ABILITY = "; p abilities

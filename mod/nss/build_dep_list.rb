#!/usr/bin/env ruby

compileable = []

# n depends on nss

def get_externs_for(file)
  externs = []
  IO.readlines(file).each {|line|
    line.strip!
    if line =~ /^#include "(.*)"\s*$/ || line =~ /^\s*extern\("(.*)"\)\s*$/
      dep = $1
      dep.downcase!
      externs << dep
    end
  }
  externs
end

def get_is_compileable(file)
  data = IO.read(file)
  return data =~ /^\s*void\s+main\s*\(\)/ ||
    data =~ /^\s*int\s+StartingConditional\(\)\s*\(\)/
end


global_externs = get_externs_for('global/stddef.h')
new = []
global_externs.each {|ext|
  externs = get_externs_for('global/' + ext)
  new << 'global/' + ext
  new.concat externs
}
global_externs = new
global_externs.concat ['_const.nh']
global_externs.uniq!

puts "global_externs := %s"  % global_externs.join(' ')

ARGV.each {|file|
  nssdep = []
  ncsdep = []

  externs = get_externs_for(file)
#  externs.concat global_externs
  nssdep << '$(global_externs)'

  is_compileable = get_is_compileable(file)

  externs.each {|dep|
    extension = File.extname(dep).gsub(".", "")

    case extension
      when "nh", "h"
        dep_exists = ( FileTest.exists?(dep) || FileTest.exists?('global/' + dep) )
        nssdep << dep
      else
        dep_exists = FileTest.exists?(dep + ".n")
        # We want to make a .n
        # First, we need the preprocessed file
        # ncsdep: ncs depends on nss
        ncsdep << dep + ".nss" if dep_exists

        # nssdep: nss depends on on (preprocess step)
        nssdep << dep + ".n" if dep_exists
    end
  }

  compileable << file if is_compileable

  if file =~ /\.nh$/
    puts "%s: %s" % [file, nssdep.join(' ')] if nssdep.size > 0
  else
    puts "%s: %s" % [file + "ss", nssdep.join(' ')] if nssdep.size > 0
    puts "%s: %s" % [file + "cs", ncsdep.join(' ')] if ncsdep.size > 0
  end
}
puts "objects := %s" % compileable.join(' ')

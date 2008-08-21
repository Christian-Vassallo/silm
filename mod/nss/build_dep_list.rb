#!/usr/bin/env ruby

compileable = []

# n depends on nss

ARGV.each {|file|
  nssdep = []
  ncsdep = []
  is_compileable = false

  IO.readlines(file).each {|line|
    line.strip!
    if line =~ /^#include "(.*)"\s*$/ || line =~ /^\s*extern\("(.*)"\)\s*$/
      dep = $1
      dep.downcase!

      dep_exists = FileTest.exists?(dep + ".n")

      # We want to make a .n
      # First, we need the preprocessed file
      # ncsdep: ncs depends on nss
      ncsdep << dep + ".nss" if dep_exists

      # nssdep: nss depends on on (preprocess step)
      nssdep << dep + ".n" if dep_exists
    end

    is_compileable = true if
      line =~ /^\s*void\s+main\s*\(\)/ ||
      line =~ /^\s*int\s+StartingConditional\(\)\s*\(\)/
  }

  compileable << file if is_compileable

  puts "%s: %s" % [file + "ss", nssdep.join(' ')] if nssdep.size > 0
  puts "%s: %s" % [file + "cs", ncsdep.join(' ')] if ncsdep.size > 0
}
puts "objects := %s" % compileable.join(' ')

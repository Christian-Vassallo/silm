#!/usr/bin/env ruby

ENCODING = 'windows-1252'

require 'optparse'
require 'find'

ARGV.each do |aa|
  fail "file #{aa} is > 16 chars!" if File.basename(aa).size > 16 + 4
end

$subdirs = Find.find(".").select {|x| File.directory?(x) } # + ["../../gamedata/override"]

def lookup file, default = nil
  $subdirs.each do |d|
    return d + "/" + file if FileTest.exists?(d + "/" + file)
  end
  if default then default else raise "Not found: #{file}" end
end

$global_includes = []
OptionParser.new do |o|
  o.on "-g file", "global include, which will be added to each file before parsing/compiling" do |g|
    $global_includes << g
  end
end.parse!

# Returns all included file names for this file. Extensions are sanitized.
def get_includes_and_externs_for(file)
  file = lookup(file)
  includes = []
  externs = []

  IO.readlines(file, :encoding => ENCODING).each {|line|
    case line.strip
      when /^#include "(.*)"\s*$/
        dep = $1.downcase
        includes << lookup(dep)
      when /^\s*extern\("(.*)"\)\s*$/
        dep = $1.downcase + ".n"
        externs << lookup(dep) rescue FileTest.exists?("../../gamedata/override/#{dep}ss") or
          $stderr.puts "Error: #{file} externs #{dep}, which does not exist"
    end
  }

  [includes, externs]
end

def get_is_compileable(file)
  data = IO.read(file, :encoding => ENCODING)
  return data =~ /^\s*void\s+main\s*\(\)/ ||
    data =~ /^\s*int\s+StartingConditional\s*\(\)/
end

def print_depend file, *argv
  a = argv.flatten.compact.reject {|v|v == ""}.uniq
  puts "%s: %s" % [file, a.join(' ')] if a.size > 0
end

# First, parse all global dependencies.

$global_depends_on = $global_includes
$global_includes.each {|file|
  file_depends_on = get_includes_and_externs_for(file).flatten
  $global_depends_on.concat file_depends_on
}
$global_depends_on.uniq!

$objects  = ARGV.select {|file| get_is_compileable(file) }.map {|file| "out/" + File.basename(file).split('.')[0..-2].join('.') }
$includes, $externs = {}, {}
ARGV.each {|file| $includes[file], $externs[file] = *get_includes_and_externs_for(file) }

puts "global_dependencies := %s" % $global_depends_on.join(' ')
puts "objects := %s" % $objects.map{|v| v + ".ncs" }.join(' ')
puts ""

depends = {}

ARGV.each {|file|
  extension = File.extname(file)
  file_without_extension = "out/" + File.basename(file).split('.')[0..-2].join('.')

  # Filter our non-existing source files (we assume they're NWN core).
  includes = $includes[file].reject {|f| !File.exists?(f) }
  externs  =  $externs[file].reject {|f| !File.exists?(f) }

  case extension
    when ".n"
      # to make the .ncs, we need a .nss of the same name
      (depends[file_without_extension + ".ncs"] ||= []) << file_without_extension + ".nss" if $objects.index(file_without_extension)

      # to make the .nss, we need the .n
      (depends[file_without_extension + ".nss"] ||= []) << file

      # and all #included files need to be checked as well:
      (depends[file_without_extension + ".nss"] ||= []) << includes
      (depends[file_without_extension + ".nss"] ||= []) << externs

      # and we need all files, that the included files extern:
      (depends[file_without_extension + ".nss"] ||= []) << includes.map {|v| $includes[v] }
      (depends[file_without_extension + ".nss"] ||= []) << includes.map {|v| $externs[v]  }

      # to make the .ncs, we need all extern()ed files to be properly preprocessed
      (depends[file_without_extension + ".ncs"] ||= [] ) << externs.map {|v| "out/" + File.basename(v) + "ss" }

    when ".h", ".nh"
      depends[file] ||= []
      depends[file] << includes
      depends[file] << externs
  end
}

depends.each {|file, depends|
  print_depend file, depends
}

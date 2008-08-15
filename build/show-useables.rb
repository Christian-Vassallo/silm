#!/usr/bin/env ruby
# This script prints out all placeables that are flagged as
# useable.

require 'rubygems'
require 'nwn/gff'
require 'nwn/yaml'
require 'yaml'

$quit = false
trap "INT", proc { $quit = true }

count = ARGV.size
curr = 0
for file in ARGV do
  curr += 1
  puts "#{file} (#{curr}/#{count}): "
  $stdout.flush

  gff = YAML.load(IO.read(file))
  
  gff['Placeable List'].value.each {|p|
    if p['Useable'].value == 1 && p['Static'].value == 0
      puts "  %-32s %2x:%2x" % [ p['Tag'].value, p['X'].value, p['Y'].value ]
      puts "    %s" % [ p.keys.select {|k| k =~ /^On/ }.map {|k| p[k].value}.join(' ') ]
    end
  }

  break if $quit
end

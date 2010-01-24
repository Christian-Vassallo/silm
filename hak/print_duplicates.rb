#!/usr/bin/env ruby
require 'digest/md5'

# Example usage:
# ls -1 ~/nwn/resources_169/*.mdl | ./check_models.rb **/*.mdl
#
# This prints out all files that are common to both sources.

a = []
a_ = []
b = []
b_ = []

ARGV.each {|file|
  fail "argv: cannot see file: #{file}" if !FileTest.exists?(file)
  a << file
  a_ << File.basename(file).downcase
}

$stdin.each {|file|
  file.strip!
  fail "stdin: cannot see file: #{file}" if !FileTest.exists?(file)
  b << file
  b_ << File.basename(file).downcase
}

x_ = a_ & b_

y_ = []
x_.reject! {|file|
  md5_a_ = Digest::MD5.hexdigest(IO.read(a[a_.index(file)]))
  md5_b_ = Digest::MD5.hexdigest(IO.read(b[b_.index(file)]))
  if md5_a_ == md5_b_
    y_ << a[a_.index(file)]
    true
  else
    false
  end
}

x_.each {|file|
  puts "%s" % [file]
}

puts "a: %d" % a_.size
puts "b: %d" % b_.size
puts "x: %d" % x_.size
puts "y: %d" % y_.size
puts y_.inspect

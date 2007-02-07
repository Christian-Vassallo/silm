#!/usr/bin/ruby -w
require 'rubygems'
require_gem 'progressbar'

$target = ARGV.shift or fail "No target specified."
$source = ARGV.size == 0 ? nil : ARGV or fail "No source specified."

$threads = 8

$i = {}

def save
  $i.freeze
  f = File.new($target, "wb")
  Marshal.dump($i, f)
  f.close
  puts "written: #{$i.size}"
  
  f = File.new($target, "rb")
  i = Marshal.load(f)
  f.close
  puts "verified loading: #{i.size}"
end

trap "SIGINT", proc {save; exit}
trap "SIGTERM", proc {save; exit}

items = $source
puts "source size = #{items.size}"
p = ProgressBar.new("read", items.size)

per_thread = items.size / $threads
thri = []
for t in 0..$threads do
	base = t * per_thread
	thri[t] = items[base, per_thread].compact
	puts "assign: #{base} -> #{base + per_thread}"
	puts " thri[t] = #{thri[t].size}"
end

thri.each do |tit|
	tit.each do |n|
		d = `gffprint.pl #{n}`
		d =~ %r{^/(?:Template)?ResRef:\s+([a-z0-9_]+)$}mi
		resref = $1 
		d =~ %r{^/Tag:\s+([^/]+)$}mi
		tag = $1 
		d =~ %r{^/(?:Localized|First)?Name/4:\s+(.+)$}
		name = $1
		name += " " + $1 if d =~ %r{^/LastName/4:\s+(.+)$}
		#d =~ %r{^/AddCost:\s+(\d+)$}
		#addcost = $1
		#d =~ %r{^/Plot:\s+(\d+)$}
		#plot = $1
		#d =~ %r{^/Stolen:\s+(\d+)$}
		#stolen = $1
		#d =~ %r{^/PaletteID:\s+(\d+)$}
		#palette = $1
		#d =~ %r{^/BaseItem:\s+(\d+)$}
		#baseitem = $1
		#d =~ %r{^/StackSize:\s+(\d+)$}
		#stacksize = $1
		#d =~ %r{^/Cursed:\s+(\d+)$}
		#cursed = $1

		if name == ""
			puts "Skipping #{resref}"
			next
		end

		$i[resref] = {
			:resref => resref,
			:tag => tag, 
			:name => name,

			#:addcost => addcost.to_i,
			#:plot => plot.to_i,
			#:stolen => stolen.to_i,
			#:palette => palette.to_i,
			#:baseitem => baseitem.to_i,
			#:stacksize => stacksize.to_i,
			#:cursed => cursed.to_i
		}

		# puts resref
		p.inc
	end
end
p.finish

save
exit


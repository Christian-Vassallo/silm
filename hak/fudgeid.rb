require 'yaml'

OFFSET = 8463

$idmap = YAML.load(IO.read("idmap"))

#p $idmap
#fail

for x in ARGV do
  gff = need x, :utp

  cid = (gff / 'Appearance').v

  next if cid < 1500

  #next if (gff / 'Appearance').v > OFFSET

  old_id = $idmap[cid]
  if old_id
    # puts "LOG #{x} #{cid} -> #{old_id}"
    (gff / 'Appearance').v = old_id
    save gff
  else
     $stderr.puts "old id not found: #{cid} for #{x}"
  end

  #puts (gff / 'Appearance$') + OFFSET
end

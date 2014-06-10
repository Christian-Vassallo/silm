require 'nwn/all'
require 'ruby-progressbar'
require 'fileutils'
require 'pp'
require 'yaml'

include NWN

cep  = TwoDA::Table.parse(IO.read("placeables.2da"))
silm = TwoDA::Table.parse(IO.read("placeables_silm.2da"))

# CEP import starts at 10000
silm.rows << [""] * silm.columns.size while silm.rows.size < 10000

# puts silm.to_2da ; exit

$notfound = []
$models   = []
$textures = []

$idmap = {}

rows = cep.rows.each_with_index.to_a[847..-1]

rows.reject! {|row| row[0].Label == ""}

rows.reject! {|row| !FileTest.exists?("src/#{row[0].ModelName}.mdl") }

$p = ProgressBar.create(:title => "placeables", :starting_at => 0, :total => rows.size)

rows.each do |(row, idx)|
  mdl = row.ModelName
  #next if row.Label == ""

  fn = "src/#{mdl}.mdl"
  # prefer decompiled models
  fn += ".ascii" if FileTest.exists?(fn + ".ascii")

  unless FileTest.exists?(fn)
    fail "should never happen" # $stderr.puts "#{mdl}.mdl does not exist"

  else
    # find all needed bitmaps/textures
    # p mdl
    bitmaps = IO.readlines(fn, encoding: 'windows-1252').map(&:strip).map {|ln|
      ln =~ /^(bitmap|texture) (.+)$/
      $2
    }.flatten.compact

    # p bitmaps

    fail "#{fn} has no bitmaps" if bitmaps.size == 0

    $models << mdl
    $textures << bitmaps
  end

  $idmap[idx] = silm.rows.size

  silm.rows << row

  $p.increment
end

$models = $models.flatten.compact.uniq
$textures = $textures.flatten.compact.uniq

# pp $textures; exit

$models.each do |mdl|
  mdl.downcase!
  FileUtils.copy("src/#{mdl}.mdl", "dst/")
  # copy placeable walkmesh too
  if FileTest.exists?("src/#{mdl}.pwk")
    FileUtils.copy("src/#{mdl}.pwk", "dst/")
  end
end
$textures.each do |tex|
  tex.downcase!
  if FileTest.exists?("src/#{tex}.dds")
    FileUtils.copy("src/#{tex}.dds", "dst/")
  elsif FileTest.exists?("src/#{tex}.tga")
    FileUtils.copy("src/#{tex}.tga", "dst/")
  else
    $stderr.puts "Texture #{tex} not found"
  end
end

File.open("out.2da", "w") do |f|
  f.puts silm.to_2da
end

File.open("idmap", "w") do |f|
  YAML.dump($idmap, f)
end

puts "mdl: %d/%d, tex: %d" % [$models.size, rows.size, $textures.size]

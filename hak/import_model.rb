#!/usr/bin/env nwn-dsl

model = ARGV.shift or fail "Specify model to import as the first argument."
$target = ARGV.shift or fail "Specify import target directory as the second argument."

FileTest.exists?(model) or fail "Not found."

File.basename(model).downcase =~ /^([a-z]+)_([a-z])_(\d+)(\d).mdl$/ or fail "Not a model?"
$model_class, $model_pos, $model_id, $model_color = $1, $2, $3.to_i, $4.to_i

log "Importing model: #{model.inspect}"

$min_offset = 100

$RESOURCES = []
$RESOURCES << "/home/elven/nwn/resources_169/"
Dir["client_*/"].each do |d|
  $RESOURCES << File.expand_path(d) if FileTest.directory?(d)
end

$IMPORT = []
$IMPORT << "/home/elven/nwn/resources_cep21"

$index = []
$RESOURCES.each {|dir|
  log "Resources: Indexing #{dir}"
  $index += Dir[dir + "/*"]
}
log "Done, found #{$index.size} files."

$import = []
$IMPORT.each {|dir|
  log "Importable: Indexing #{dir}"
  $import += Dir[dir + "/*"]
}
log "Done, found #{$import.size} files."

baseitems = TwoDA::Cache.get("baseitems")
$baseitem = baseitems.by_col("ItemClass").map {|x| x.downcase }.index($model_class)
log "Baseitem of this model is: #{$baseitem.inspect}"
$minrange = baseitems.by_row(8, "MinRange").to_i
$maxrange = baseitems.by_row(8, "MaxRange").to_i
log "MinRange/MaxRange is: #{$minrange}/#{$maxrange}"

# Lets find a free ID to ram this into.
taken_ids = $index.map {|x|
  if x =~ /(?:^|\/)#{$model_class}_#{$model_pos}_(\d+)\d.mdl$/i
    $1.to_i
  else
    nil
  end
}.compact.sort

# $new_id = $min_offset
# $new_id += 1 while taken_ids.index($new_id)
$new_id = taken_ids[-1] + 1
log "New model ID will be: #{$new_id}"
$new_color = 1

$actions = []


# now find all colors of this model
all_models = $import.select {|x| x =~ /(?:^|\/)#{$model_class}_#{$model_pos}_#{$model_id}(\d).(?:mdl)$/i }
log "FYI: all colors of this model: #{all_models.inspect}"

# TODO: find supermodel for each, and import


# find icon and import
tt = nil
if $import.select {|x| x =~ /(?:^|\/)i#{$model_class}_#{$model_pos}_#{$model_id}#{$model_color}.(?:tga|dds)$/i && tt = x}.size > 0
  log "Found item: #{tt}."
  $actions << lambda { FileUtils.cp(tt, $target + "/i%s_%s_%d%d.tga" % [$model_class, $model_pos, $new_id, $new_color], :verbose => true)  }
else
  fail "Cannot find icon to import."
end

# find all textures this model needs
$textures = IO.readlines(model).map {|x| x =~ /^\s*bitmap\s+(.+?)\s*$/i ? $1 : nil}.compact.uniq
log "This model needs the following textures: #{$textures.inspect}"
$textures.each {|t|
  tt = nil

  if $index.select {|x| x =~ /(?:^|\/)#{t}.(?:tga|dds)$/i && tt = x}.size > 0
    log "#{tt}: we have that already."
    next
  end

  if $import.select {|x| x =~ /(?:^|\/)#{t}.(?:tga|dds)$/i && tt = x}.size > 0
    log "#{tt}: Will import."
    $actions << lambda { FileUtils.cp(tt, $target + "/" + File.basename(tt), :verbose => true) }
  else
    fail "Can't find resource #{t}, bailing."
  end
}

$actions << lambda { FileUtils.cp(model, $target + "/%s_%s_%d%d.mdl" % [$model_class, $model_pos, $new_id, $new_color], :verbose => true) }

log "Alright, lets do it."
#$actions.each {|a| a.call }

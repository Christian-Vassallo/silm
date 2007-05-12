#!/usr/bin/ruby


source = ARGV.shift or fail "No source specified."
target = ARGV.shift or fail "No target specified."

if !File::exists?(source)
	fail "Source does not exist."
end

if source !~ /(.+)\.([^\.]+)$/
	fail "No extension"
end

path = File::dirname(source)
base = File::basename(source)
ext = $2

field = "/" + case ext
	when "uti", "utc", "utp"
		"TemplateResRef"
	else
		fail "Unsupported extension: #{ext}"
end

fail "system(gffmodify.pl) failed" if
	!system("gffmodify.pl",
		"-m", "#{field}=#{target.downcase}",
		"-m", "/Tag=#{target}",
	source)

fail "system(svn mv) failed" if 
	!system("svn", "mv", "--force", "--non-interactive", source, target)

# File::move(source, target + "." + ext)

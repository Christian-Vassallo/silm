#!/bin/sh

ls -1 {~/nwn/resources_169/,./client_*}/*.mdl | ruby -ryaml -e '
mdl = {}
while $stdin.gets
	if $_ =~ /([^\/\d]+?)(\d{3})\.mdl$/
		m = $1.downcase
		i = $2.to_i
		mdl[m] ||= 0
		mdl[m] = i if mdl[m] < i
	end
end
y mdl
'

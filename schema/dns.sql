create schema dns;

create function dns.getname(src varchar) returns varchar as
$_$
	require 'resolv'
	Resolv.getname(src).to_s
rescue
	src
$_$ language 'plruby';

create function dns.getaddress(src varchar) returns varchar as
$_$
	require 'resolv'
	Resolv.getaddress(src).to_s
rescue
	src
$_$ language 'plruby';

create function dns.getnames(src varchar) returns varchar[] as
$_$
	require 'resolv'
	Resolv.getnames(src)
rescue
	[src]
$_$ language 'plruby';

create function dns.getaddresses(src varchar) returns varchar[] as
$_$
	require 'resolv'
	Resolv.getaddresses(src)
rescue
	[src]
$_$ language 'plruby';

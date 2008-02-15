create function plruby_call_handler() returns language_handler
	as '/usr/local/lib/site_ruby/1.8/i486-linux/plruby.so'
	language 'C';

CREATE TRUSTED LANGUAGE 'plruby'
	HANDLER plruby_call_handler
	LANCOMPILER 'PL/Ruby';

create table plruby_singleton_methods (name varchar, args varchar, body varchar);

insert into plruby_singleton_methods (name) values('***');

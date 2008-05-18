create schema sessions;
create table sessions.sessions (
	id serial8 primary key,
	aid int references accounts (id) not null,
	cid int references characters(id),
	session_start timestamptz default now() not null,
	session_end timestamptz,
	session_failed boolean default false not null
);


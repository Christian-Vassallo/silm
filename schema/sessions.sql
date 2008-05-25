create schema sessions;
create table sessions.sessions (
	id serial8 primary key,
	aid int references accounts (id) not null,
	cid int references characters(id),
	session_start timestamptz default now() not null,
	session_end timestamptz,
	session_failed boolean default false not null
);

create view sessions.aggregator as
	select
		*,
		session_end-session_start as duration,
		(select count(id) from chat.logs 
			where (mode & 1=1 or mode & 4 = 4 or mode & 16 = 16)
			and (
				session = sessions.id or (heard_by_cid @> ARRAY[coalesce(sessions.sessions.cid,0)])
				and ts >= sessions.sessions.session_start
				and ts <= sessions.sessions.session_end
			) 
		) as message_count 
	from sessions.sessions;



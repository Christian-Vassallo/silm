create schema chat;
CREATE TABLE chat.logs (
    id serial primary key,

	ts timestamptz default now() not null,

	-- The speaker
	aid int,
	cid int,
	character_s varchar not null,
	account_s varchar not null, 
	at location not null,

	-- The target (if any)
	t_aid int,
	t_cid int,
	t_character_s varchar,
	t_account_s varchar, 
	t_at location,

	-- Who heard this stuff?
	heard_by_aid int[] default '{}' not null,
	heard_by_cid int[] default '{}' not null,

	-- The session
	session int references sessions.sessions(id) not null,

	mode int not null,

	text text not null
);
create index logs_session_idx on chat.logs (session);
create index logs_aid_idx on chat.logs (aid);
create index logs_cid_idx on chat.logs (aid);
create index heard_by_aid_idx on chat.logs using gist (heard_by_aid gist__int_ops);
create index heard_by_cid_idx on chat.logs using gist (heard_by_cid gist__int_ops);

--create function get_lastlog_for(cid int,area varchar,lim int) returns setof chatlogs
--as $$
--        select * from chatlogs
--                where
--                (character = $1 or $1 = any(heard_by))
--                and
--                (mode & 1 > 0 or mode & 2 > 0 or mode & 4 > 0 or mode & 16 > 0)
--                and
--                area = $2
--                order by ts desc limit $3;
--
--$$ language sql stable;

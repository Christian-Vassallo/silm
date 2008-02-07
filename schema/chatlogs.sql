CREATE TABLE chatlogs (
    id serial unique primary key not null,
    account integer DEFAULT 0 NOT NULL,
    "character" integer DEFAULT 0 NOT NULL,
    account_s character varying,
    character_s character varying,
    t_account integer DEFAULT 0 NOT NULL,
    t_character integer DEFAULT 0 NOT NULL,
    t_account_s character varying,
    t_character_s character varying,
    area character varying,
    ts timestamp with time zone DEFAULT now(),
    text text,
    "mode" integer,
	heard_by int[] default '{}' not null
);

CREATE INDEX chatlog_ts_idx ON chatlogs USING btree (ts);
create index chatlogs_heard_by_idx on chatlogs (heard_by);
create index chatlogs_area_list_idx on chatlogs (area);

create function get_lastlog_for(cid int,area varchar,lim int) returns setof chatlogs
as $$
        select * from chatlogs
                where
                (character = $1 or $1 = any(heard_by))
                and
                (mode & 1 > 0 or mode & 2 > 0 or mode & 4 > 0 or mode & 16 > 0)
                and
                area = $2
                order by ts desc limit $3;

$$ language sql stable;

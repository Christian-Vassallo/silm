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

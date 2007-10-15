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
    "mode" integer
);

CREATE INDEX chatlog_ts_idx ON chatlogs USING btree (ts);

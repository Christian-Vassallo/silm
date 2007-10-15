CREATE TABLE online (
    id serial unique primary key not null,
    aid integer references accounts NOT NULL,
    cid integer references characters,
    account character varying NOT NULL,
    "character" character varying NOT NULL,
    dm boolean default false NOT NULL,
    area character varying NOT NULL,
    x double precision NOT NULL,
    y double precision NOT NULL,
    z double precision NOT NULL,
    f double precision NOT NULL,
    afk boolean DEFAULT false NOT NULL,
    area_s character varying DEFAULT ''::character varying
);

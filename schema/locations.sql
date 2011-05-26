CREATE TABLE locations (
    id serial primary key,
    name character varying NOT NULL,
    area character varying NOT NULL,
    x double precision DEFAULT 0 NOT NULL,
    y double precision DEFAULT 0 NOT NULL,
    z double precision DEFAULT 0 NOT NULL,
	restricted boolean default true not null
);

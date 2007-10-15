CREATE TABLE tracks (
    id serial unique primary key not null,
    "character" integer references characters not null,
    area character varying not null,
    x double precision not null,
    y double precision not null,
    facing double precision not null,
    age integer not null,
    deep integer not null,
    size integer not null,
    gender integer not null,
    speed integer not null,
    barefoot boolean not null
);

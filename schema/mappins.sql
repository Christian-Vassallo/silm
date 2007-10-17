CREATE TABLE mappins (
    id serial unique primary key not null,
    "character" integer references characters not null,
    text text default '' not null,
    x double precision not null,
    y double precision not null,
    area character varying not null
);

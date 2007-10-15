CREATE TABLE xp (
    id serial unique primary key not null,
    "character" integer references characters,
    xp integer default 0 not null,
    "year" integer not null,
    "month" integer not null,
    "day" integer not null,
    ts timestamptz default now() not null,

    constraint xp_character_key UNIQUE ("character", "year", "month", "day")
);

CREATE TABLE combat_xp (
) INHERITS (xp);


CREATE TABLE gm_xp (
    account_gms integer[]
) INHERITS (xp);


CREATE TABLE time_xp (
) INHERITS (xp);

CREATE TABLE kills (
    id serial unique primary key not null, 
    ts timestamptz DEFAULT now() not null,
    killer_id integer references characters not null,
    area_resref character varying(32) not null
);

CREATE TABLE monster_kills (
    resref character varying(32) unique not null,
    count integer default 0 not null,

	unique (killer_id, resref)

) INHERITS (kills);

CREATE TABLE pc_kills (
    killee_id integer
) INHERITS (kills);

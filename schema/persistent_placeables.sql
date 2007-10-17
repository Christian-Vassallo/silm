CREATE TABLE placeables (
	id serial unique primary key not null,
    resref character varying NOT NULL,
    area character varying NOT NULL,
    x double precision NOT NULL,
    y double precision NOT NULL,
    z double precision NOT NULL,
    f double precision NOT NULL,
    name character varying(255) NOT NULL,
    locked boolean NOT NULL,
    last_access timestamp with time zone DEFAULT now(),
    lock_key character varying(255) NOT NULL,
    store_tag character varying(100) NOT NULL,
    first_placed_by integer references characters,
    last_placed_by integer references characters
);

CREATE INDEX placeables_area_idx ON placeables USING btree (area);


CREATE TABLE scene_descriptions (
	id serial unique primary key not null,
    pid integer NOT NULL,
    text text NOT NULL,
    "comment" text NOT NULL,
    locked boolean DEFAULT false
);

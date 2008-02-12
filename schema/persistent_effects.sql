CREATE TABLE persistent_effects (
	id serial primary key,
    "character" integer references characters not null,

	-- TODO constrain this
    apply_when character varying,
    effect character varying,
    duration_type character varying,
    duration double precision DEFAULT 0,
    veffect integer,

    CONSTRAINT persistent_effects_when_check CHECK (((apply_when)::text = 'enter'::text))
);

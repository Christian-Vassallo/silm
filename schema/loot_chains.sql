CREATE TABLE loot_chains (
	id serial unique primary key not null,
    racial_type integer DEFAULT -1 NOT NULL,
    resref character varying DEFAULT '%'::character varying NOT NULL,
    tag character varying DEFAULT '%'::character varying NOT NULL,
    name character varying DEFAULT '%'::character varying NOT NULL,
    lvar character varying DEFAULT '%'::character varying NOT NULL,
    "order" integer DEFAULT 1 NOT NULL,
    "replace" integer DEFAULT 0 NOT NULL,
    loot text DEFAULT ''::text NOT NULL,
    chance double precision DEFAULT (1)::double precision NOT NULL,
    log boolean DEFAULT false NOT NULL,
    uniq boolean DEFAULT false NOT NULL
);


CREATE VIEW loot_aggregator AS
    SELECT loot_chains.loot, loot_chains."replace", loot_chains.racial_type, loot_chains.resref, loot_chains.tag, loot_chains.name FROM loot_chains WHERE ((random() - loot_chains.chance) <= (0)::double precision) ORDER BY loot_chains.racial_type, loot_chains.tag, loot_chains.resref, loot_chains.name, loot_chains."order";

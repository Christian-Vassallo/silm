CREATE TABLE gem_chains (
    id serial primary key,

    racial_type integer DEFAULT -1 NOT NULL,
    resref character varying DEFAULT '%'::character varying NOT NULL,
    tag character varying DEFAULT '%'::character varying NOT NULL,
    name character varying DEFAULT '%'::character varying NOT NULL,
    lvar character varying DEFAULT '%'::character varying NOT NULL,
    "order" integer DEFAULT 1 NOT NULL,
    "replace" integer DEFAULT 0 NOT NULL,
    loot text DEFAULT ''::text NOT NULL,
    chance double precision DEFAULT (1)::double precision NOT NULL,
    stone character varying(16) DEFAULT ''::character varying NOT NULL,
    area character varying(64) DEFAULT ''::character varying NOT NULL
);

CREATE VIEW loot_gem_aggregator AS
    SELECT gem_chains.loot, gem_chains."replace", gem_chains.area, gem_chains.stone FROM gem_chains WHERE ((random() - gem_chains.chance) <= (0)::double precision) ORDER BY gem_chains.area, gem_chains.stone, gem_chains."order";

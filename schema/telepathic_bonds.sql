CREATE TABLE telepathic_bonds (
    id serial unique primary key not null,
    "character" integer references characters not null,
    t_character integer references characters not null,
    ts timestamp with time zone DEFAULT now(),
    active boolean DEFAULT true,
    shortname character varying,
    expire integer DEFAULT 0 NOT NULL,
	
	unique ("character", t_character),
	
	check ("character" <> t_character)
);

CREATE TABLE telepathic_bonds (
    id serial primary key,
    "character" integer references characters not null,
    t_character integer references characters not null,
    ts timestamp not null default now(),
    active boolean not null default true,
	send_heard boolean not null default false,
	send_spoken boolean not null default false,
    shortname not null character varying,
    expire integer not null defaul t0,
	
	unique ("character", t_character),
	
	check ("character" <> t_character)
);

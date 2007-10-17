CREATE TABLE mentors (
    id serial unique primary key not null,
    id integer NOT NULL,
    account integer,
    charge integer DEFAULT 0,
    charge_per_hour integer DEFAULT 23,
    capacity integer DEFAULT 300,
    amount_per_pc integer DEFAULT 30,
    flags integer DEFAULT 31,
    last_charge_cycle integer
);

CREATE TABLE mentordata (
    id serial unique primary key not null,
    ts timestamp with time zone DEFAULT now(),
    account integer unique references accounts not null,
    "character" integer references characters not null,
    t_character integer references characters not null,
    xp integer default 0 not null,

	unique ("character", t_character);
);

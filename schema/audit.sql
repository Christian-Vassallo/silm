CREATE TABLE audit (
    id serial unique primary key not null,
    player character varying NOT NULL,
    "char" character varying NOT NULL,
    "location" character varying NOT NULL,
    flags character varying NOT NULL,
    date timestamp with time zone DEFAULT now() NOT NULL,
    category character varying DEFAULT 'module'::character varying,
    event character varying NOT NULL,
    data text NOT NULL,
    tplayer character varying NOT NULL,
    tchar character varying NOT NULL
);

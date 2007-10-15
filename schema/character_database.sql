CREATE TABLE accounts (
    id serial unique primary key not null,
    account character varying,
    "password" character varying,
    display_name character varying,
    status character varying DEFAULT 'accept'::character varying NOT NULL,
    amask bigint DEFAULT 0 NOT NULL,
    create_on timestamp with time zone DEFAULT now(),
    last_login timestamp with time zone DEFAULT now() NOT NULL,
    register_on timestamp with time zone,
    total_time bigint,
    playername character varying,
    sex character varying,
    email character varying,
    roleplay_experience text,
    dm boolean DEFAULT false,
    playerage integer,
    CONSTRAINT accounts_sex_check CHECK (((sex)::text = ANY ((ARRAY['m'::character varying, 'f'::character varying, 'n'::character varying])::text[]))),
    CONSTRAINT accounts_status_check CHECK (((status)::text = ANY ((ARRAY['accept'::character varying, 'reject'::character varying, 'ban'::character varying])::text[])))
);

CREATE UNIQUE INDEX account_unique ON accounts USING btree (account);



CREATE TABLE characters (
    id serial unique primary key not null,
    account integer references accounts not null,
    "character" character varying NOT NULL,
    race character varying,
    subrace character varying,
    sex character(1),
    age integer,
    birthday timestamp without time zone,
    create_on timestamp with time zone DEFAULT now(),
    register_on timestamp with time zone,
    last_access timestamp with time zone,
    messages integer,
    total_time integer DEFAULT 0 NOT NULL,
    create_ip inet,
    create_key character(8),
    other_keys character varying DEFAULT ''::character varying NOT NULL,
    alignment_moral integer,
    alignment_ethical integer,
    xp integer,
    xp_combat integer,
    dead boolean,
    death_count integer,
    gold integer,
    class1 character varying,
    class1_level integer,
    class2 character varying,
    class2_level integer,
    class3 character varying,
    class3_level integer,
    domain1 character varying,
    domain2 character varying,
    deity character varying,
    familiar_class character varying,
    familiar_name character varying,
    description text,
    str integer,
    con integer,
    dex integer,
    "int" integer,
    wis integer,
    chr integer,
    will integer,
    reflex integer,
    fortitude integer,
    status character varying DEFAULT 'new'::character varying,
    appearance text,
    traits text,
    biography text,
    area character varying,
    x double precision,
    y double precision,
    z double precision,
    f double precision,
    locked boolean DEFAULT false,
    legacy_xp integer DEFAULT 0,
    filename character varying DEFAULT ''::character varying,
    dm character varying DEFAULT ''::character varying,
    last_login timestamp with time zone,
    CONSTRAINT characters_class1_level_check CHECK ((class1_level >= 1)),
    CONSTRAINT characters_class2_level_check CHECK ((class2_level >= 0)),
    CONSTRAINT characters_class3_level_check CHECK ((class3_level >= 0)),
    CONSTRAINT characters_gold_check CHECK ((gold >= 0)),
    CONSTRAINT characters_sex_check CHECK ((sex = ANY (ARRAY['m'::bpchar, 'f'::bpchar, 'n'::bpchar]))),
    CONSTRAINT characters_status_check CHECK (((status)::text = ANY ((ARRAY['new'::character varying, 'new_register'::character varying, 'register'::character varying, 'register_accept'::character varying, 'accept'::character varying, 'reject'::character varying, 'ban'::character varying, 'delete'::character varying, 'dead'::character varying])::text[]))),
    CONSTRAINT characters_xp_check CHECK ((xp >= 0)),
    CONSTRAINT characters_xp_check1 CHECK ((xp >= 0))
);

CREATE INDEX characters_idx ON characters USING btree ("character");


CREATE VIEW character_map AS
    SELECT accounts.id AS account_id, accounts.account, characters.id AS character_id, characters."character", characters.xp FROM accounts, characters WHERE (accounts.id = characters.account) ORDER BY accounts.id;



CREATE TABLE comments (
    id serial unique primary key not null,
    date timestamp with time zone DEFAULT now() NOT NULL,
    status character varying DEFAULT 'private'::character varying NOT NULL,
    "character" integer references characters not null,
    body text not null,
    account integer references accounts not null
);

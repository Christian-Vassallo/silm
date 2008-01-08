CREATE TABLE online (
    id serial unique primary key not null,
    aid integer references accounts NOT NULL,
    cid integer references characters,
    account character varying NOT NULL,
    "character" character varying NOT NULL,
    dm boolean default false NOT NULL,
    area character varying NOT NULL,
    x double precision NOT NULL,
    y double precision NOT NULL,
    z double precision NOT NULL,
    f double precision NOT NULL,
    afk boolean DEFAULT false NOT NULL,
    area_s character varying DEFAULT ''::character varying
);

create view online_aggregator as
	SELECT
		online.id, online.aid, online.cid, online.account, online."character", 
		online.dm, online.area, online.x, online.y, online.z, online.f, online.afk, online.area_s,
		characters.race, characters.subrace, characters.xp, characters.class1, 
		characters.class1_level, characters.class2, characters.class2_level, 
		characters.class3, characters.class3_level
   FROM online
		LEFT JOIN characters ON characters.id = online.cid;

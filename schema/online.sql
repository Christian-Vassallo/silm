CREATE TABLE online (
    id serial primary key,
    aid integer references accounts not null,
    cid integer references characters,
    account character varying not null,
    "character" character varying not null,
    dm boolean default false not null,
    afk boolean DEFAULT false not null,
	at location not null
);

create view online_aggregator as
	SELECT
		online.id, online.aid, online.cid, online.account, online."character", 
		online.dm, online.at, online.afk,
		characters.race, characters.subrace, characters.xp, characters.class1, 
		characters.class1_level, characters.class2, characters.class2_level, 
		characters.class3, characters.class3_level
   FROM online
		LEFT JOIN characters ON characters.id = online.cid;

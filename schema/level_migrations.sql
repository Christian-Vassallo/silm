create schema level_migrations;

create table level_migrations.migrations (
    id integer not null,
    xp_amount int not null,
    start_date timestamp not null,
    name character varying not null,

	unique(name)
);

create table level_migrations.migrated_characters (
    id serial primary key,
    migration int references level_migrations.migrations not null,
    cid int references characters not null,
    paid_on timestamp not null,

	unique(migration, cid)
);

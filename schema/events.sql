-- Schema: events
--
create schema events;


-- Table: events
-- This table contains all event scripts.
create table events.events (
	id serial8 primary key not null,
	script varchar(16) not null,
	eventtype int not null default 0,
	eventmask int not null default 0,
	sync boolean not null default false,
	runnable_tagmask varchar(32),
	runnable_refmask varchar(16),
	actor_tagmask varchar(32),
	actor_refmask varchar(16),
	actedon_tagmask varchar(32),
	actedon_refmask varchar(16),
	ordering int default 0 not null,
	enabled boolean not null default false
);

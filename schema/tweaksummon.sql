create schema tweaksummon;

create table tweaksummon.appearance (
	id serial primary key,
	cid int references characters not null,
	associate int not null,
	appearance int,
	tail int,
	portrait varchar,
	name varchar,
	description varchar

	unique (cid, associate)
);
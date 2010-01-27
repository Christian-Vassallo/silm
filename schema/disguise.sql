create table disguise (
	id serial primary key,
	created_on timestamp default now() not null,
	updated_on timestamp default now() not null,
	cid integer references characters not null,
	name character varying not null,
	gender integer not null,
	appearance integer not null,
	head integer not null,
	wings integer not null,
	tail integer not null,
	hair integer not null,
	skin integer not null,
	tattoo1 integer not null,
	tattoo2 integer not null,
	portrait character varying not null,
	description text,

	unique (cid, name)
);

create table dynamic_names (
	id serial primary key,
	player integer references characters not null,
	target integer references characters not null,
	disguise integer references disguise,
	name character varying not null,
	set_on default now() not null,

	unique (player, target, disguise)
);

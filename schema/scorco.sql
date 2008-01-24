-- SCO/RCO support for psql_base

create table instance_objects (
	id serial primary key,

	resref resref not null,
	tag tag not null,

	create_on timestamp default now() not null,

	data bytea not null
);

create table named_objects (
	name varchar,

	x float,
	y float,
	z float,
	area resref

) inherits (instance_objects);

create table item_objects (
	inventory_x int,
	inventory_y int,
	inventory_page int,

	character_id int references characters

) inherits (named_objects);


create table placeable_objects (
	appearance_id int
) inherits (named_objects);


create table creature_objects (
	appearance_id int
) inherits (named_objects);

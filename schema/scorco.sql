-- SCO/RCO support for psql_base

create table instance_objects (
	id serial primary key,

	create_on timestamp default now() not null,

	data bytea not null
);

create table named_objects (
	resref resref not null,
	tag tag not null,

	name varchar,

	area resref
	x float,
	y float,
	z float,


) inherits (instance_objects);

create table item_objects (

--	inventory_x int,
--	inventory_y int,
--	inventory_page int,
--	character_id int references characters

) inherits (named_objects);

create table creature_objects (

--	appearance_id int

) inherits (named_objects);

create table player_objects (
	
--	account_id int references characters not null,
--	character_id int references characters not null,

) inherits (creature_objects);

create table dm_objects (

--	account_id int references characters not null,

) inherits (creature_objects);

-- SCO/RCO support for psql_base

create schema scorco;

create table scorco.object_ids (
	id serial primary key,
	create_on timestamp default now() not null,
	last_access_on timestamp default now() not null
);


create table scorco.object_metadata (
--	objtype objecttype not null,

	resref resref not null,
	tag tag not null,

	name varchar,

	area resref,
	x float,
	y float,
	z float,
	f float,
	
	data bytea

) inherits (scorco.object_ids);

create function scorco.touch_object(int) returns int
	as $$ update scorco.object_ids set last_access_on = now() where id = $1; select $1 $$
	language sql;

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

	area_resref resref,
	area_tag tag,
	x float,
	y float,
	z float,
	f float,
	
	data bytea

) inherits (scorco.object_ids);

create view scorco.metadata_info as 
	select
		p.relname,id,create_on,last_access_on,resref,tag,name,area_resref,area_tag,x,y,z,f
		from scorco.object_metadata c, pg_class p
		where c.tableoid = p.oid;

create function scorco.touch_object(int) returns int
	as $$ update scorco.object_ids set last_access_on = now() where id = $1; select $1 $$
	language sql;


create table scorco.dropped_items (
) inherits (scorco.object_metadata);

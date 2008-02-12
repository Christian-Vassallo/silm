-- SCO/RCO support for psql_base

create schema scorco;

create table scorco.object_ids (
	id serial primary key,
	create_on timestamp default now() not null,
	last_access_on timestamp default now() not null
);

create table scorco.object_data (
	data bytea
) inherits (scorco.object_ids);

create table scorco.object_metadata (
--	objtype objecttype not null,

	resref resref not null,
	tag tag not null,

	name varchar,

	hitpoints int,

	at location,
	
) inherits (scorco.object_data);

create view scorco.metadata_info as 
	select
		p.relname,id,create_on,last_access_on,resref,tag,name,hitpoints,at,length(data) as size
		from scorco.object_metadata c, pg_class p
		where c.tableoid = p.oid;

create function scorco.touch_object(int) returns int
	as $$ update scorco.object_ids set last_access_on = now() where id = $1; select $1 $$
	language sql;


create table scorco.dropped_items (
) inherits (scorco.object_metadata);

create table scorco.critters (
) inherits (scorco.object_metadata);


create table scorco.character_data (
	int aid references accounts not null,
	int cid references characters
) inherits (scorco.object_data);

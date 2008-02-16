-- SCO/RCO support for psql_base

-- use cases:
--  * plain storage, no data
--  * item in container
--  * item in area
--  * creature in area

create schema scorco;

-- Object data

create table scorco.object_data (
	id serial8 primary key,
	create_on timestamp default now() not null,
	access_on timestamp default now() not null,
	data bytea
);

-- Metadata

create table scorco.object_metadata (
-- 	metadata_id serial8 primary key
	-- object_data_id int references scorco.object_data not null
) inherits (scorco.object_data);

create table scorco.object_attr_metadata (
	resref resref,
	tag tag,
	name varchar,
	hitpoints_current int,
	hitpoints_max int,
	plot boolean,
	weight int
) inherits (scorco.object_metadata);

create table scorco.object_creature_metadata (
	creature_appearance int
) inherits (scorco.object_metadata);

create table scorco.object_item_metadata (
	item_ac int,
	item_base_type int,
	item_charges int default 0
) inherits (scorco.object_metadata);

create table scorco.object_location_metadata (
	at location
) inherits (scorco.object_metadata);

create table scorco.object_placeable_metadata (
	pid int references placeables
) inherits (scorco.object_metadata);

create table scorco.object_account_metadata (
	cid int references characters
) inherits (scorco.object_metadata);

create table scorco.object_character_metadata (
	cid int references characters
) inherits (scorco.object_metadata);

create table scorco.object_last_access_by_metadata (
	aid int references accounts,
	cid int references characters
) inherits (scorco.object_metadata);

-- --
-- Implementation below

-- Items on the ground
create table scorco.dropped_items (
) inherits (scorco.object_attr_metadata, scorco.object_item_metadata, scorco.object_location_metadata, scorco.object_last_access_by_metadata);

-- Items in a public container
create table scorco.public_container_contents (
) inherits (scorco.object_attr_metadata, scorco.object_item_metadata, scorco.object_placeable_metadata, scorco.object_last_access_by_metadata);

-- Items in a private container.
create table scorco.personal_container_contents (
) inherits (scorco.object_attr_metadata, scorco.object_item_metadata, scorco.object_placeable_metadata);


-- Creatures on the ground somewhere
create table scorco.critters (
) inherits (scorco.object_attr_metadata, scorco.object_location_metadata);

-- Copies of logged-in characters
create table scorco.player_copies (
) inherits (scorco.object_metadata, scorco.object_character_metadata);

-- Information only:

-- TODO: select ((at).area).tag, count(id), sum(length(data)) as bytes from scorco.dropped_items group by ((at).area).tag;

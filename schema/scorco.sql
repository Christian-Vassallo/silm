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
	data gff
--	xml_data xml
);
-- create rule scorco.object_data_xml_update as
-- 	on insert or update to scorco.object_data do also
-- 	update scorco.object_data set xml_data = gff.toxml(NEW.data);

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


create function scorco.touch_object(int) returns void as $_$
	update scorco.object_ids set last_access_on = now() where id = $1 
$_$ language sql;


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

create view scorco.critters_area_info as
SELECT (critters.at).area.tag AS tag, area_tag_to_name((critters.at).area.tag::character varying) AS area_tag_to_name, count(critters.data) AS count, sum(length(critters.data)) AS bytes
FROM scorco.critters
GROUP BY (critters.at).area.tag
ORDER BY count(critters.data) DESC;

create view scorco.critters_area_detail_info as
SELECT (critters.at).area.tag AS tag, area_tag_to_name((critters.at).area.tag::character varying) AS area_tag_to_name, critters.resref, count(critters.resref) AS count, sum(length(critters.data)) AS bytes
FROM scorco.critters
GROUP BY (critters.at).area.tag, critters.resref
ORDER BY count(critters.resref) DESC;

create view scorco.dropped_items_area_info as
SELECT (dropped_items.at).area.tag AS tag, area_tag_to_name((dropped_items.at).area.tag::character varying) AS area_tag_to_name, count(dropped_items.data) AS count, sum(length(dropped_items.data)) AS bytes
FROM scorco.dropped_items
GROUP BY (dropped_items.at).area.tag
ORDER BY count(dropped_items.data) DESC;

create view scorco.dropped_items_list as
SELECT dropped_items.name, dropped_items.resref, dropped_items.tag, dropped_items.create_on, dropped_items.aid, dropped_items.cid, cid_to_str(dropped_items.cid) AS cid_to_str, length(dropped_items.data) AS bytes, (dropped_items.at).area AS area
FROM scorco.dropped_items;

create view scorco.dropped_items_area_detail_info as
SELECT (dropped_items.at).area.tag AS tag, area_tag_to_name((dropped_items.at).area.tag::character varying) AS area_tag_to_name, dropped_items.resref, count(dropped_items.resref) AS count, sum(length(dropped_items.data)) AS bytes
FROM scorco.dropped_items
GROUP BY (dropped_items.at).area.tag, dropped_items.resref
ORDER BY count(dropped_items.resref) DESC;

-- TODO: select ((at).area).tag, count(id), sum(length(data)) as bytes from scorco.dropped_items group by ((at).area).tag;

-- Schema: objects
--
-- SCO/RCO support for psql_base

create schema objects;

-- Function: objects.objects_update_md
create function objects.objects_update_md() returns trigger as $_$
begin
	if (TG_OP = 'UPDATE') then
		NEW.update_on := now();
	end if;
--	if (TG_OP = 'INSERT') then
--		NEW.type := substring(lower(((xpath('/gff/@type', NEW.data))[1])::text) from 1 for 3)::restype;
--	end if;
	return NEW;
end;
$_$ language 'plpgsql';

-- Object data
create table objects.objects (
	id serial8 primary key,
	create_on timestamp default now() not null,
	update_on timestamp,
	
	at location,

	data gff
);


-- --
-- Implementation

-- Table: dropped_items
-- Items on the ground
create table objects.dropped_items (
	dropped_by_aid int references accounts,
	dropped_by_cid int references characters
) inherits (objects.objects);
create trigger objects_update_md
	before insert or update
	on objects.dropped_items for each row 
	execute procedure objects.objects_update_md();

-- Table: iron_flask
-- Items on the ground
create table objects.iron_flask (
) inherits (objects.objects);
create trigger objects_update_md
	before insert or update
	on objects.iron_flask for each row 
	execute procedure objects.objects_update_md();

create table dcont (
	id serial primary key,
	last_opened_by_aid int references accounts,
	last_opened_by_cid int references characters,
	created_at timestamp default now() not null,
	last_opened_at timestamp default now() not null,
	last_opened_where location
);

-- Table: dcont
-- Items in dynamic containers
create table objects.dcont (
	container int not null
) inherits (objects.objects);
create trigger objects_update_md
	before insert or update
	on objects.cont for each row 
	execute procedure objects.objects_update_md();

-- Table: trashbox
-- Items thrown into sigil boxes
create table objects.trashbox (
	aid int,
	cid int
) inherits (objects.objects);
create trigger objects_update_md
	before insert or update
	on objects.trashbox for each row 
	execute procedure objects.objects_update_md();

-- Table: critters
-- Creatures on the ground somewhere
create table objects.critters (
) inherits (objects.objects);
create trigger objects_update_md
	before insert or update
	on objects.critters for each row 
	execute procedure objects.objects_update_md();

-- Table: characters
-- Character data
create table objects.characters (
	character_id int references characters not null
) inherits (objects.objects);
create trigger objects_update_md
	before insert or update
	on objects.characters for each row 
	execute procedure objects.objects_update_md();


-- Table: audit
-- Audit trail objects
create table objects.audit (
	audit_id int references audit
) inherits (objects.objects);
create trigger objects_update_md
	before insert or update
	on objects.audit for each row 
	execute procedure objects.objects_update_md();


-- Table: templates
-- /tpl templates
create table objects.templates (
	name varchar,
	tag varchar,
	resref varchar
) inherits (objects.objects);
create trigger objects_update_md
	before insert or update
	on objects.templates for each row
	execute procedure objects.objects_update_md();

-- Table: buried_items
-- Items buried below-grounds
create table objects.buried_items (
	buried_by_aid int references accounts,
	buried_by_cid int references characters
) inherits (objects.objects);
create trigger objects_update_md
	before insert or update
	on objects.buried_items for each row 
	execute procedure objects.objects_update_md();

-- Items in a public container
--create table objects.public_container_contents (
--	int container_id references placeables
--) inherits (objects.objects);




-- Information only:

--create view objects.md as
--	select id, create_on, access_on, at, type,
--
--	gff.x_el('TemplateResRef', xml_data) as resref,
--	gff.x_el('Tag', xml_data) as tag,
--	(case when t.type = 'bic'
--		then
--			array_to_string(xpath('/gff/struct/element[@name="FirstName" or @name="LastName"]/localString[@languageId=4 or @languageId=0]/@value', xml_data), ' ')
--		else
--			(xpath('/gff/struct/element[@name="LocalizedName"]/localString[@languageId=4]/@value', xml_data))[1]::varchar
--	end) as name,
--	gff.x_el('Plot', xml_data)::varchar::int::boolean as plot
--from objects.objects o;
--
--
--create view objects.md_creatures as
--	select m.*,
--	(enum_range(null::racetype))[gff.x_el('Race', xml_data)::varchar::int]::racetype as race,
--	gff.x_el('Subrace', xml_data) as subrace,
--
--	gff.x_el('Str', xml_data) as str,
--	gff.x_el('Dex', xml_data) as dex,
--	gff.x_el('Int', xml_data) as int,
--	gff.x_el('Wis', xml_data) as wis,
--	gff.x_el('Con', xml_data) as con,
--	gff.x_el('Cha', xml_data) as cha
--from objects.objects o, scorco.metadata m where o.id = m.id and (m.type = 'bic' or m.type = 'utc');




--create view objects.critters_area_info as
--SELECT (critters.at).area.tag AS tag, area_tag_to_name((critters.at).area.tag::character varying) AS area_tag_to_name, count(critters.data) AS count, sum(length(critters.data)) AS bytes
--FROM objects.critters
--GROUP BY (critters.at).area.tag
--ORDER BY count(critters.data) DESC;
--
--create view objects.critters_area_detail_info as
--SELECT (critters.at).area.tag AS tag, area_tag_to_name((critters.at).area.tag::character varying) AS area_tag_to_name, critters.resref, count(critters.resref) AS count, sum(length(critters.data)) AS bytes
--FROM objects.critters
--GROUP BY (critters.at).area.tag, critters.resref
--ORDER BY count(critters.resref) DESC;
--
--create view objects.dropped_items_area_info as
--SELECT (dropped_items.at).area.tag AS tag, area_tag_to_name((dropped_items.at).area.tag::character varying) AS area_tag_to_name, count(dropped_items.data) AS count, sum(length(dropped_items.data)) AS bytes
--FROM objects.dropped_items
--GROUP BY (dropped_items.at).area.tag
--ORDER BY count(dropped_items.data) DESC;
--
--create view objects.dropped_items_list as
--SELECT dropped_items.name, dropped_items.resref, dropped_items.tag, dropped_items.create_on, dropped_items.aid, dropped_items.cid, cid_to_str(dropped_items.cid) AS cid_to_str, length(dropped_items.data) AS bytes, (dropped_items.at).area AS area
--FROM objects.dropped_items;
--
--create view objects.dropped_items_area_detail_info as
--SELECT (dropped_items.at).area.tag AS tag, area_tag_to_name((dropped_items.at).area.tag::character varying) AS area_tag_to_name, dropped_items.resref, count(dropped_items.resref) AS count, sum(length(dropped_items.data)) AS bytes
--FROM objects.dropped_items
--GROUP BY (dropped_items.at).area.tag, dropped_items.resref
--ORDER BY count(dropped_items.resref) DESC;
--
-- TODO: select ((at).area).tag, count(id), sum(length(data)) as bytes from objects.dropped_items group by ((at).area).tag;

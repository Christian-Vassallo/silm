-- File: base.sql
-- This is the base SQL schema.
-- You will absolutely need all of the things contained herein.

-- Domain: resref
create domain resref as varchar
	check (length(VALUE) > 0 and length(VALUE) <= 16);

-- Domain: tag
create domain tag as varchar
	check (length(VALUE) > 0 and length(VALUE) <= 32);

-- Type: resdesc
create type resdesc as (tag tag, resref resref);

-- Enum: restype
create type restype as enum('bic','are','git','gic','uti','utc','utm','utp','ute','utd','uts','itp','utw','dlg','utt','ncs');

-- Type: vector
create type vector as (x float, y float, z float);

-- Type: location
create type location as (area resdesc, position vector, facing float);

-- Enum: racetype
create type racetype as enum('dwarf', 'elf', 'gnome', 'halfling', 'halfelf', 'halforc', 'human');

-- create domain objecttype as varchar
--	check (VALUE = any(ARRAY['']));

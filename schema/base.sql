-- This is the base SQL schema.
-- You will absolutely need all of the things contained herein.


create domain resref as varchar
	check (length(VALUE) > 0 and length(VALUE) <= 16);

create domain tag as varchar
	check (length(VALUE) > 0 and length(VALUE) <= 32);

create type vector as (x float, y float, z float);
create type area as (tag tag, resref resref);
create type location as (area area, position vector, facing float);

-- create domain objecttype as varchar
--	check (VALUE = any(ARRAY['']));

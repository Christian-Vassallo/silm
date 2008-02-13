-- This is the base SQL schema.
-- You will absolutely need all of the things contained herein.


create domain resref as varchar
	check (length(VALUE) > 0 and length(VALUE) <= 16);

create domain tag as varchar
	check (length(VALUE) > 0 and length(VALUE) <= 32);

create type resdesc as (tag tag, resref resref);

create type vector as (x float, y float, z float);
create type location as (area resdesc, position vector, facing float);

-- create domain objecttype as varchar
--	check (VALUE = any(ARRAY['']));

-- This is the base SQL schema.
-- You will absolutely need all of the things contained herein.


create domain resref as varchar
	check (length(VALUE) > 0 and length(VALUE) <= 16);

create domain tag as varchar
	check (length(VALUE) > 0 and length(VALUE) <= 32);

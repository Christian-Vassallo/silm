CREATE FUNCTION clamp(thisc integer, min integer, max integer) RETURNS integer
    AS $_$select case when $1 < $2 then $2 else (case when $1 > $3 then $3 else $1 end) end$_$
    LANGUAGE sql;


CREATE FUNCTION lowest_int(integer, integer) RETURNS integer
    AS $_$select case when ($1 > $2) then $2 else $1 end$_$
    LANGUAGE sql IMMUTABLE STRICT;


CREATE FUNCTION sha1(text) RETURNS text
    AS $_$
SELECT
ENCODE(public.DIGEST($1, 'sha1'),'hex') AS result
$_$
    LANGUAGE sql;


CREATE FUNCTION unix_timestamp() RETURNS integer
    AS $$select date_part('epoch', now())::int;$$
    LANGUAGE sql STABLE;


CREATE FUNCTION unixts() RETURNS integer
    AS $$select date_part('epoch', now())::int;$$
    LANGUAGE sql STABLE;

CREATE FUNCTION aid_to_str(int) returns varchar
	as 'select account from accounts where id = $1;'
	language sql stable;

create function cid_to_str(int) returns varchar
	as 'select character from characters where id = $1;'
	language sql stable;


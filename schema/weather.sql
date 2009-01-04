CREATE TABLE weather_overrides (
    id serial primary key,
    account integer references accounts NOT NULL,
    atype character varying NOT NULL,
    ayear integer NOT NULL,
    amonth integer NOT NULL,
    aday integer NOT NULL,
    zyear integer NOT NULL,
    zmonth integer NOT NULL,
    zday integer NOT NULL,
    "temp" integer NOT NULL,
    wind integer NOT NULL,
    prec integer NOT NULL
);

create schema weather;

create function weather.getweather(resref varchar, tileset varchar, mask int, year int, month int, day int, hour int, minute int) returns bytea as
$_$
	require 'rmnx';
	require 'mnx_temp';
	r = CommandTemperature.new
	return r.mnx_getweather(resref, tileset, mask, year, month, day, hour, minute)
$_$ language 'plruby';


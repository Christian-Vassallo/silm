CREATE TABLE weather_overrides (
    id serial unique primary key not null,
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

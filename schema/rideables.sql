CREATE TABLE rideables (
    id serial unique primary key not null,
    "character" integer references characters not null,
    "stable" character varying NOT NULL,
    "type" character varying not null,
    phenotype integer,
    name character varying,
    delivered_in_hour integer NOT NULL,
    delivered_in_day integer NOT NULL,
    delivered_in_month integer NOT NULL,
    delivered_in_year integer NOT NULL,
    bought boolean DEFAULT false,
    pay_rent boolean DEFAULT true,
    
	unique ("character"),

	check ((("type")::text = ANY ((ARRAY['Pferd'::character varying, 'Pony'::character varying])::text[])))
);

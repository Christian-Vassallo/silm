CREATE TABLE gv (
    id serial primary key,
    "key" character varying NOT NULL,
    "type" character varying DEFAULT 'int'::character varying,
    
	value text NOT NULL,
    amask integer DEFAULT 0 not null,

    CONSTRAINT gv_type_check CHECK ((("type")::text = ANY ((ARRAY['int'::character varying, 'string'::character varying, 'float'::character varying])::text[]))),

	unique ("key", "type")
);

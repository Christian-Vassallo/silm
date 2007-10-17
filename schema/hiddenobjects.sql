CREATE TABLE hiddenobject_resources (
    id serial unique primary key not null,
    name character varying DEFAULT ''::character varying NOT NULL,
    typ character varying DEFAULT ''::character varying NOT NULL,
    resref character varying(16) DEFAULT ''::character varying NOT NULL,
    dc integer DEFAULT 10,
    value integer DEFAULT 0,
    bonus character varying(10) DEFAULT 0
);

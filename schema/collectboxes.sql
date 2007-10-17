CREATE TABLE collectboxes (
    id serial unique primary key not null,
    name character varying unique not null,
    value integer default 0 not null
);

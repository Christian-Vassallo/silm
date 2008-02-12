CREATE TABLE collectboxes (
    id serial primary key,
    name character varying unique not null,
    value integer default 0 not null
);

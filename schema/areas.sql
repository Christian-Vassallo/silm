create table areas (
	id serial primary key,
	resref varchar(16) unique not null,
	name varchar not null
);
create index areas_resref_idx on areas(resref);

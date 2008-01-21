create table areas (
	id serial unique primary key not null,
	resref varchar(16) unique not null,
	name varchar not null
);
create index areas_resref_idx on areas(resref);

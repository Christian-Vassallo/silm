create table matcomp (
	id serial primary key,
	spell int unique not null,
	component varchar,
	afocus varchar,
	dfocus varchar
);

create schema spbookmgr;

create table spbookmgr.states (
	id serial primary key,
	created_on timestamp default now() not null,
	updated_on timestamp default now() not null,

	character int references characters not null,
	name varchar not null,

	unique (character, name)
);

create table spbookmgr.memorized (
	id serial primary key,
	state int references spbookmgr.states not null,
	level int not null,
	class int not null,
	spell int not null,
	meta int not null,
	index int not null,

	check (class >= 0 and class <= 255),
	check (level >= 0 and level <= 9),
	check (index >= 0),
	unique (state, level, class, index)
);

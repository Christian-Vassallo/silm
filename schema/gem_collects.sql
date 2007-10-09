drop table gem_collects cascade;
create table gem_collects (
	id serial not null unique primary key,
	"character" int references characters not null,
	resref varchar(32) not null,
	amount int not null default 0,

	unique (character, resref)
);


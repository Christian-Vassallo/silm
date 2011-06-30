create table xplock (
	id serial primary key,
	cid int references characters not null,
	xp int not null
);

create table last_location (
	id serial primary key,

	cid int unique references characters not null,
	
	at location
);

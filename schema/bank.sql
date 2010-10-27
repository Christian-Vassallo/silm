create schema bank;

create table bank.banks (
	id serial primary key,
	created_on timestamp not null default now(),

	name varchar not null
);
alter sequence bank.banks_id_seq restart with 1000;

create table bank.accounts (
	id serial primary key,
	created_on timestamp not null default now(),
	bank int references bank.banks not null,

	balance int not null default 0
);
alter sequence bank.accounts_id_seq restart with 1000;

create table bank.access (
	id serial primary key,
	created_on timestamp not null default now(),

	account int references bank.accounts not null,
	cid int references characters not null
);
alter sequence bank.access_id_seq restart with 1000;

create table bank.tx (
	id serial primary key,
	created_on timestamp not null default now(),

	account int references bank.accounts not null,
	cid int references characters not null,
	
	value int not null
);
alter sequence bank.tx_id_seq restart with 1000;

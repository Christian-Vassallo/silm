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
	accessed_on timestamp not null default now(),
	updated_on timestamp not null default now(),
	bank int references bank.banks not null,

	name varchar,

	credit int not null default 0,
	balance int not null default 0
);
alter sequence bank.accounts_id_seq restart with 1000;

create table bank.access (
	id serial primary key,
	created_on timestamp not null default now(),

	account int references bank.accounts not null,
	cid int references characters not null,

	allow_read bool not null default true,
	allow_withdraw bool not null default false,
	allow_deposit bool not null default false
);
alter sequence bank.access_id_seq restart with 1000;

create table bank.tx (
	id serial primary key,
	created_on timestamp not null default now(),

	account int references bank.accounts not null,
	cid int references characters,
	name varchar,

	interest float not null default 0.05,
	credit_interest float not null default 0.36,

	value int not null,
	balance_after int not null,

	item int references objects.objects
);
alter sequence bank.tx_id_seq restart with 1000;

create function bank.interest_for(account int) returns int as $$
select
	-- tx.balance_after * a.interest  = yearly interest
	-- days passed: extract(epoch from now() - tx.created_on) / 3600 / 24
	-- fraction fo year: days_passed / 365
	(
	tx.balance_after * (case when tx.balance_after >= 0
			then a.interest else a.credit_interest end) *
	(extract(epoch from now() - tx.created_on) / 3600 / 24) / 365
	)::int

	from bank.tx as tx
	left join bank.accounts as a on a.id = tx.account
	where account = $1 order by tx.id desc limit 1;
$$ language sql stable;

create schema bank;

create table bank.banks (
	id serial primary key,
	created_on timestamp not null default now(),

	interest float not null default 0.05,
	credit_interest float not null default 0.36,

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

	interest float,
	credit_interest float,

	suspended bool default false not null,

	credit int not null default 0,
	balance int not null default 0
);
alter sequence bank.accounts_id_seq restart with 1000;

create table bank.access (
	id serial primary key,
	created_on timestamp not null default now(),

	account int references bank.accounts not null,
	cid int references characters not null,

	default_income bool not null default false,

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

	value int not null,
	balance_after int not null,

	interest bool not null default false,

	item int references objects.objects
);
alter sequence bank.tx_id_seq restart with 1000;

create function bank.interest_for(account int) returns int as $$
select
	-- tx.balance_after * a.interest  = yearly interest
	-- days passed: extract(epoch from now() - tx.created_on) / 3600 / 24
	-- fraction fo year: days_passed / 365
	(
	tx.balance_after * (case when tx.balance_after >= 0 then
			coalesce(a.interest, b.interest)
		else
			coalesce(a.credit_interest, b.credit_interest) end) *
	(extract(epoch from now() - tx.created_on) / 3600 / 24) / 365
	)::int

	from bank.tx as tx
	left join bank.accounts as a on a.id = tx.account
	left join bank.banks as b on b.id = a.bank
	where account = $1 order by tx.id desc limit 1;
$$ language sql stable;

create function bank.pay_interest_for(acc int) returns int as $$
declare
	interest int;
	since varchar;
begin
	-- select bank.interest_for(acc)
	select bank.interest_for(acc) into interest;
	select 'Zinsen seit ' || to_char(t.created_on, 'DD.MM.YY HH24:MI') from bank.tx as t
		where account = acc order by id desc limit 1 into since;

	if interest != 0 then
		perform bank.txn(acc, interest, null, since, true);
	end if;

	return interest;
end;
$$ language plpgsql;


create function bank.txn(acc int, val int, bycid int, byname varchar, isinteresttx bool) returns int as $
declare
	balanceval integer;
begin
	select "balance" from bank.accounts where id = acc into balanceval;
	if val != 0 then
		if isinteresttx = false then
			perform bank.pay_interest_for(acc);
		end if;
		insert into bank.tx ("account", "cid", "name", "value", "balance_after", "interest")
		values(
			acc, bycid, byname, val, balanceval + val, isinteresttx
		);

		update bank.accounts set "balance" = "balance" + val, updated_on = now()
			where id = acc;
	end if;

	return balanceval + val;
end;
$$ language plpgsql;

create function bank.txn2(accfrom int, val int, accto int, bycid int, byname varchar) returns int as $$
begin
	perform bank.txn(accfrom, - val, bycid, byname, false);
	perform bank.txn(accto,   + val, bycid, byname, false);
	return val;
end;
$$ language plpgsql;

-- Returns the canonical, unique printable account identifier
-- of the given account.
create function bank.canonical_account_name(accid int) returns varchar as $$
	select b.id::varchar || '-' || a.id::varchar
	from bank.banks b, bank.accounts a
	where a.bank = b.id and a.id = $1;
$$ language sql stable;

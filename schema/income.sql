drop schema income cascade;
create schema income;


-- A source defines how much a certain profession pays off.
-- the ratio given is per DAY and will be multiplied with
-- the actual time passed.
create table income.sources (
	id serial primary key,

	name varchar not null,

	-- set this to a skills.2da entry ID to give (d20 + skill_mod) * skill_factor copper coins.
	skill int not null default -1, -- we cant use null, because nwscript doesn't support a distinctive nil datatype

	-- set this to true to only use the base skill without feats, items and temporaries.
	skill_base bool not null default false,

	-- multiply the skill check with this value
	skill_factor float not null default 1.0,

	-- the copper value payed each day.  This is additive to the skill-result, if a skill is defined.
	copper int not null default 0,

	-- the minimum timespan paid out
	min_days_pay float not null default 1.0,

	-- the maximum timespan paid out (rest will not be paid, if absent longer than that)
	max_days_backpay float not null default 7.0
);

create table income.mappings (
	id serial primary key,

	cid int references characters not null,

	source int references income.sources not null,

	created_at timestamp not null default now()
);

create table income.payments (
	id serial primary key,

	mapping int references income.mappings not null,

	-- when has this been collected?
	paydate timestamp not null default now(),

	-- what was actually paid, in copper
	copper int not null
);


create function income.days_since_last_payment(mapping int) returns float as
$$
	select
		extract(epoch from (now() - coalesce((select paydate from income.payments where mapping = m.id order by paydate desc limit 1), m.created_at)))::float/60/60/24
	from income.mappings m, income.sources s
	where s.id = m.source and m.id = $1;

$$ language sql stable;


create function income.payment_due(mapping int, skillmod int, max_days float) returns int as
$$
	select (
		copper::float * clamp(income.days_since_last_payment($1), 0.0, $3)
			+
		case
			when s.skill > -1
		then
			(10 + $2)::float * s.skill_factor * clamp(income.days_since_last_payment($1), 0.0, $3)
		else
			0
		end
	)::int
	from income.mappings m, income.sources s
	where s.id = m.source and m.id = $1;

$$ language sql stable;

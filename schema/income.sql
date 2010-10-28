drop schema income cascade;
create schema income;


-- A source defines how much a certain profession pays off.
-- the ratio given is per DAY and will be multiplied with
-- the actual time passed.
create table income.sources (
	id serial primary key,

	name varchar not null,

	-- set this to a abilities.2da entry ID to give (d20 + ability_mod) * ability_factor copper coins.
	ability int not null default -1, -- we cant use null, because nwscript doesn't support a distinctive nil datatype

	-- the maximum skill mod applicable
	ability_max int not null default -1,

	-- set this to true to only use the base ability without feats, items and temporaries.
	ability_base bool not null default false,

	-- multiply the ability check with this value
	ability_factor float not null default 1.0,


	-- set this to a skills.2da entry ID to give (d20 + skill_mod) * skill_factor copper coins.
	skill int not null default -1, -- we cant use null, because nwscript doesn't support a distinctive nil datatype

	-- set this to true to only use the base skill without feats, items and temporaries.
	skill_base bool not null default false,

	-- the maximum skill mod applicable
	skill_max int not null default -1,

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

	cid int references characters,
	bank_account int references bank.accounts,

	source int references income.sources not null,

	created_at timestamp not null default now(),

	enabled boolean not null default true,

	unique (cid, source)
);

create table income.exclusion (
	id serial primary key,

	cid int references characters not null,

	source int references income.sources
);

create table income.payments (
	id serial primary key,


	cid int references characters not null,
	mapping int references income.mappings not null,

	-- when has this been collected?
	paydate timestamp not null default now(),

	-- what was actually paid, in copper
	copper int not null
);


create function income.days_since_last_payment(cid int, mapping int) returns float as
$$
	select coalesce((select
		extract(epoch from (now() - coalesce((select paydate from income.payments where mapping = m.id and cid = $1 order by paydate desc limit 1), m.created_at)))::float/60/60/24
	from income.mappings m, income.sources s
	where s.id = m.source and m.id = $2), 0.0);

$$ language sql stable;


create function income.payment_due(cid int, mapping int, abilitymod int, skillmod int, max_days float) returns int as
$$
	select coalesce((select (
		copper::float * clamp(income.days_since_last_payment($1, $2), 0.0, $5)
			+
		case when s.skill > -1 then
			case when s.skill_max > -1 then
				(10 + clamp($4, 0, s.skill_max))::float * s.skill_factor * clamp(income.days_since_last_payment($1, $2), 0.0, $5)
			else
				(10 + $4)::float * s.skill_factor * clamp(income.days_since_last_payment($1, $2), 0.0, $5)
			end
		else
			0
		end
			+
		case when s.ability > -1 then
			case when s.ability_max > -1 then
				(10 + clamp($3, 0, s.ability_max))::float * s.ability_factor * clamp(income.days_since_last_payment($1, $2), 0.0, $5)
			else
				(10 + $3)::float * s.ability_factor * clamp(income.days_since_last_payment($1, $2), 0.0, $5)
			end
		else
			0
		end
	)::int
	from income.mappings m, income.sources s
	where s.id = m.source and m.id = $2), 0);

$$ language sql stable;

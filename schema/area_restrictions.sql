create table area_access (
	id serial primary key,

	area_tag varchar not null,

	account int references accounts,
	character int references characters,

--	unique (area_tag, account),
--	unique (area_tag, character),

	target_tag varchar not null,

	allow boolean default false
);

create view area_allowed as select area_tag, account, character, allow, target_tag from area_access
	where
		area_tag = area_access.area_tag and
		(account = area_access.account     or area_access.account is null) and
		(character = area_access.character or area_access.character is null)

	order by character desc, account desc limit 1;


-- begin;


-- To disallow entering to a complete area:
insert into area_access (area_tag, account, character, target_tag, allow) values ('area', null, null, 'target_object', false);

-- Then allow some accounts to enter:
insert into area_access (area_tag, account, character, target_tag, allow) values ('area', 1, null, 'target_object', true);

-- Then allow some characters to enter:
insert into area_access (area_tag, account, character, target_tag, allow) values ('area', null, 41, 'target_object', true);


-- To just forbid some players to enter, but allow all others:
insert into area_access (area_tag, account, character, target_tag, allow) values ('area', 1, null, 'target_object', false);
insert into area_access (area_tag, account, character, target_tag, allow) values ('area', null, 41, 'target_object', false);


-- rollback;

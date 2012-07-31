create schema auth;

create table auth.keys (
	id serial primary key,
	account int references public.accounts not null,
	key varchar not null,

	unique(account, key)
);

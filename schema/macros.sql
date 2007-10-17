CREATE TABLE macro (
	id serial unique primary key not null,

	-- null = for all accounts
    account integer references accounts,

    ts timestamp with time zone DEFAULT now(),
    macro character varying(128) not null,
    command text,

	unique (account, macro)
);

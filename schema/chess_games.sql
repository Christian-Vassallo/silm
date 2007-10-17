CREATE TABLE chess_games (
    id serial unique primary key not null,
    start_ts timestamp with time zone,
    end_ts timestamp with time zone DEFAULT now(),
    black integer references accounts,
    white integer references accounts,
    result character varying,
    variant character varying(32),
    log text,
    CONSTRAINT chess_games_result_check CHECK (((result)::text = ANY ((ARRAY['white'::character varying, 'black'::character varying, 'draw'::character varying, 'cancel'::character varying])::text[])))
);

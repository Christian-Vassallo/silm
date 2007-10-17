

CREATE TABLE merchants (
    id serial unique primary key not null,
    tag character varying(32) unique NOT NULL,
    money integer DEFAULT 400 NOT NULL,
    appraise_dc integer DEFAULT 10 NOT NULL,
    buy_mark double precision DEFAULT 1 NOT NULL,
    sell_mark double precision DEFAULT 1 NOT NULL,
    text_intro text DEFAULT ''::text NOT NULL,
    text_buy text DEFAULT ''::text NOT NULL,
    text_sell text DEFAULT ''::text NOT NULL,
    text_nothingtobuy text DEFAULT ''::text NOT NULL,
    text_nothingtosell text DEFAULT ''::text NOT NULL,
    text_pcnomoney text DEFAULT ''::text NOT NULL,
    text_mercnomoney text DEFAULT ''::text NOT NULL,
    "comment" text DEFAULT ''::text NOT NULL,
    money_limited integer DEFAULT 1 NOT NULL,
    text_swap character varying DEFAULT ''::character varying NOT NULL,
);


CREATE TABLE merchant_inventory (
    id serial unique primary key not null,
    ts timestamp with time zone DEFAULT now() NOT NULL,
    merchant integer references merchants NOT NULL,
    resref character varying(32) NOT NULL,
    min integer DEFAULT 0 NOT NULL,
    cur integer DEFAULT 0 NOT NULL,
    max integer DEFAULT 0 NOT NULL,
    buy_mark double precision DEFAULT 1 NOT NULL,
    sell_mark double precision DEFAULT 1 NOT NULL,
    decay double precision DEFAULT 0 NOT NULL,
    gain double precision DEFAULT 0 NOT NULL,
    "comment" text,
    last_decay integer DEFAULT 0 NOT NULL,
    last_gain integer DEFAULT 0 NOT NULL,
    sell integer,
    buy integer,
    CONSTRAINT merchant_inventory_check CHECK (((cur >= min) AND (cur <= max))),
    CONSTRAINT merchant_inventory_min_check CHECK ((min >= 0)),
);


CREATE VIEW stores AS
    SELECT merchants.id AS merchant_id, merchant_inventory.id AS inventory_id, merchants.tag, merchants.money, merchants.appraise_dc, merchant_inventory.resref, merchant_inventory.sell AS sells, merchant_inventory.buy AS buys, merchant_inventory.min, clamp(((((merchant_inventory.cur)::double precision - floor((((((unixts() - merchant_inventory.last_decay) / 60) / 60))::double precision * merchant_inventory.decay))) + floor((((((unixts() - merchant_inventory.last_gain) / 60) / 60))::double precision * merchant_inventory.gain))))::integer, merchant_inventory.min, merchant_inventory.max) AS cur, merchant_inventory.max, (merchant_inventory.buy_mark * merchants.buy_mark) AS buy_mark, (merchant_inventory.sell_mark * merchants.sell_mark) AS sell_mark FROM (merchant_inventory LEFT JOIN merchants ON ((merchants.id = merchant_inventory.merchant)));

CREATE RULE stores_update AS ON UPDATE TO stores DO INSTEAD UPDATE merchant_inventory SET cur = new.cur, last_decay = unixts(), last_gain = unixts() WHERE (((merchant_inventory.resref)::text = (old.resref)::text) AND (merchant_inventory.merchant = (SELECT merchants.id FROM merchants WHERE ((merchants.tag)::text = (old.tag)::text))));

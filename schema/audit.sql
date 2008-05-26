create table audit (
    id serial primary key,
    player varchar not null,
    "char" varchar not null,
    "location" varchar not null,
    flags varchar not null,
    date timestamptz default now() not null,
    category varchar default 'module'::varchar,
    event varchar not null,
    data text not null,
    tplayer varchar not null,
    tchar varchar not null
);

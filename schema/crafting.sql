CREATE TABLE craft_crafts (
    id serial unique primary key not null,
    cskill integer unique not null,
    tag character varying not null,
    name character varying not null,
    CONSTRAINT craft_crafts_cskill_check CHECK ((cskill > 0))
);

CREATE TABLE craft_rcpbook (
    id serial unique primary key not null,
    "character" integer references characters NOT NULL,
    cskill integer references craft_crafts(cskill) NOT NULL,
    recipe integer references craft_recipes NOT NULL,
    ts timestamptz default now(),

	unique ("character", cskill, recipe)
);

CREATE TABLE craft_recipes (
    id serial unique primary key not null,
    active boolean DEFAULT false,
    "comment" text,
    name character varying,
    cost integer DEFAULT 100,
    description text,
    resref text,
    resref_fail text,
    workplace character varying,
    components text,
    components_save_dc integer DEFAULT 12,
    cskill integer,
    cskill_min integer NOT NULL,
    cskill_max integer NOT NULL,
    practical_xp_factor double precision DEFAULT 1,
    ability integer DEFAULT 3,
    ability_dc integer DEFAULT 10,
    skill integer DEFAULT -1,
    skill_dc integer DEFAULT 10,
    feat integer DEFAULT -1,
    count_min integer DEFAULT 1,
    count_max integer DEFAULT 1,
    xp_cost double precision DEFAULT 0,
    timespan_min integer DEFAULT 1,
    lock_duration integer DEFAULT 0,
    max_per_day double precision DEFAULT 0,
    spell integer DEFAULT -1,
    spell_fail integer DEFAULT -1,
    s_craft character varying,
    d_colour character varying DEFAULT 'white'::character varying,
    CONSTRAINT cskill_recipes_check CHECK ((cskill_min <= cskill_max)),
    CONSTRAINT cskill_recipes_check1 CHECK ((count_min <= count_max)),
    CONSTRAINT cskill_recipes_count_max_check CHECK ((count_max >= 0)),
    CONSTRAINT cskill_recipes_count_min_check CHECK ((count_min >= 0)),
    CONSTRAINT cskill_recipes_cskill_max_check CHECK ((cskill_max >= 0)),
    CONSTRAINT cskill_recipes_cskill_min_check CHECK ((cskill_min >= 0))
);

CREATE TABLE craft_skill (
    id serial unique primary key not null,
    "character" integer NOT NULL,
    cskill integer NOT NULL,
    skill_theory integer DEFAULT 0 NOT NULL,
    skill_theory_xp integer DEFAULT 0 NOT NULL,
    skill_practical integer DEFAULT 0 NOT NULL,
    skill_practical_xp integer DEFAULT 0 NOT NULL
);


CREATE VIEW craft_skillmap AS
    SELECT
		craft_skill.id, craft_skill."character", craft_skill.cskill,
		craft_skill.skill_theory, craft_skill.skill_theory_xp, 
		craft_skill.skill_practical, craft_skill.skill_practical_xp, 
		COALESCE(
			(SELECT craft_recipes.cskill_max FROM craft_recipes WHERE ((craft_recipes.cskill = craft_skill.cskill) AND (craft_recipes.active = true)) ORDER BY craft_recipes.cskill_max DESC LIMIT 1),
			0
		) AS skill_practical_highest_learn_border,
		
		lowest_int(
			craft_skill.skill_practical,
			COALESCE(
				(SELECT craft_recipes.cskill_max FROM craft_recipes WHERE ((craft_recipes.cskill = craft_skill.cskill) AND (craft_recipes.active = true)) ORDER BY craft_recipes.cskill_max DESC LIMIT 1), 
				craft_skill.skill_practical
			)
		) AS skill_practical_effective, 
		
		0 AS skill_theory_effective
	FROM craft_skill;


CREATE TABLE craft_stat (
    id serial unique primary key not null,
    "character" integer references characters NOT NULL,
    recipe integer references craft_recipes NOT NULL,
    count integer DEFAULT 0 NOT NULL,
    fail integer DEFAULT 0 NOT NULL,
    "last" integer DEFAULT 0 NOT NULL
);


create function recipe_to_name(int) returns varchar 
	as 'select name from craft_recipes where id = $1;'
	language sql stable;

-- phpMyAdmin SQL Dump
-- version 2.9.0.2-Debian-1
-- http://www.phpmyadmin.net
-- 
-- Host: localhost
-- Generation Time: Feb 19, 2007 at 11:12 PM
-- Server version: 5.0.32
-- PHP Version: 5.2.0-8
-- 
-- Database: `silm_nwserver`
-- 

-- --------------------------------------------------------

-- 
-- Table structure for table `accounts`
-- 

CREATE TABLE `accounts` (
  `id` int(15) NOT NULL auto_increment,
  `account` varchar(100) NOT NULL,
  `password` varchar(64) NOT NULL,
  `display_name` varchar(100) NOT NULL,
  `status` enum('accept','reject','ban') NOT NULL default 'accept',
  `create_on` datetime NOT NULL,
  `total_time` int(15) NOT NULL,
  `last_login` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `register_on` datetime default NULL,
  `mentor` enum('true','false') default 'false',
  `dm` enum('true','false') NOT NULL default 'false',
  `amask` int(11) NOT NULL default '0',
  `mod_admin` enum('true','false') NOT NULL default 'false',
  `mod_view` enum('true','false') NOT NULL default 'false',
  `audit_view` enum('true','false') NOT NULL default 'false',
  `audit_admin` enum('true','false') NOT NULL default 'false',
  `char_view` enum('true','false') NOT NULL default 'false',
  `char_admin` enum('true','false') default 'false',
  `craft_view` enum('true','false') NOT NULL default 'false',
  `craft_admin` enum('true','false') NOT NULL default 'false',
  `object_admin` enum('true','false') NOT NULL default 'false',
  `mentor_view` enum('true','false') NOT NULL default 'false',
  `mentor_admin` enum('true','false') NOT NULL default 'false',
  `playername` varchar(200) NOT NULL,
  `sex` enum('m','f','n') NOT NULL default 'n',
  `email` varchar(255) NOT NULL,
  `playerage` int(3) NOT NULL,
  `roleplay_experience` longtext NOT NULL,
  `strftime` varchar(100) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `account` (`account`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `audit`
-- 

CREATE TABLE `audit` (
  `id` int(15) NOT NULL auto_increment,
  `player` varchar(255) NOT NULL,
  `char` varchar(255) NOT NULL,
  `location` varchar(255) NOT NULL,
  `flags` set('dm') NOT NULL,
  `date` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `category` varchar(32) default 'module',
  `event` varchar(255) NOT NULL,
  `data` longtext NOT NULL,
  `tplayer` varchar(255) NOT NULL,
  `tchar` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `blackboard_entries`
-- 

CREATE TABLE `blackboard_entries` (
  `id` int(15) NOT NULL auto_increment,
  `ts` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `blackboard` varchar(32) NOT NULL,
  `cid` int(15) NOT NULL,
  `sigil` int(1) NOT NULL,
  `sigil_label` text NOT NULL,
  `sigil_text` text NOT NULL,
  `title` text NOT NULL,
  `text` text NOT NULL,
  `explosive_runes` int(1) default '0',
  `sepia_snake_sigil` int(1) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `characters`
-- 

CREATE TABLE `characters` (
  `id` int(15) NOT NULL auto_increment,
  `account` int(15) default NULL,
  `character` tinytext,
  `filename` tinytext NOT NULL,
  `dm` enum('true','false') NOT NULL default 'false',
  `race` varchar(150) default 'Bleistift',
  `subrace` varchar(150) NOT NULL,
  `sex` enum('m','f','n') default 'n',
  `age` int(5) NOT NULL,
  `birthday` date default NULL,
  `create_on` datetime default NULL,
  `register_on` datetime default NULL,
  `last_login` datetime default NULL,
  `last_access` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `current_time` int(15) NOT NULL,
  `total_time` int(15) NOT NULL,
  `create_ip` varchar(32) NOT NULL,
  `create_key` varchar(8) NOT NULL,
  `other_keys` longtext NOT NULL,
  `alignment_moral` int(3) default '50',
  `alignment_ethical` int(3) default '50',
  `xp` int(10) default NULL,
  `xp_combat` int(15) default '-1',
  `dead` enum('true','false') NOT NULL default 'false',
  `death_count` int(15) NOT NULL,
  `gold` int(15) NOT NULL,
  `class1` varchar(100) NOT NULL default 'IT-Consultant',
  `class1_level` int(2) NOT NULL default '0',
  `class2` varchar(100) NOT NULL default 'IT-Consultant',
  `class2_level` int(2) NOT NULL default '0',
  `class3` varchar(100) NOT NULL default 'IT-Consultant',
  `class3_level` int(2) NOT NULL default '0',
  `domain1` varchar(100) default NULL,
  `domain2` varchar(100) default NULL,
  `deity` varchar(100) NOT NULL,
  `familiar_class` varchar(100) default 'None',
  `familiar_name` varchar(255) NOT NULL,
  `description` longtext NOT NULL,
  `str` int(3) NOT NULL,
  `con` int(3) NOT NULL,
  `dex` int(3) NOT NULL,
  `wis` int(3) NOT NULL,
  `int` int(3) NOT NULL,
  `chr` int(3) NOT NULL,
  `will` int(3) NOT NULL,
  `reflex` int(3) NOT NULL,
  `fortitude` int(3) NOT NULL,
  `status` enum('new','new_register','register','register_accept','register_accept_wait','accept','reject','ban','dead','delete') default 'new',
  `appearance` longtext NOT NULL,
  `traits` longtext NOT NULL,
  `biography` longtext NOT NULL,
  `area` varchar(150) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `f` float NOT NULL,
  `legacy_xp` int(1) NOT NULL default '0',
  `locked` enum('yes','no') NOT NULL default 'no',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `chatlogs`
-- 

CREATE TABLE `chatlogs` (
  `id` int(15) NOT NULL auto_increment,
  `account` int(15) NOT NULL,
  `character` int(15) NOT NULL,
  `account_s` varchar(200) NOT NULL,
  `character_s` varchar(200) NOT NULL,
  `taid` int(15) NOT NULL,
  `tcid` int(15) NOT NULL,
  `taccount` varchar(255) NOT NULL,
  `tcharacter` varchar(255) NOT NULL,
  `area` varchar(100) NOT NULL,
  `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `text` text NOT NULL,
  `mode` int(5) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `collectboxes`
-- 

CREATE TABLE `collectboxes` (
  `id` int(15) NOT NULL auto_increment,
  `name` varchar(200) NOT NULL,
  `value` int(20) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `combat_xp`
-- 

CREATE TABLE `combat_xp` (
  `id` int(15) NOT NULL auto_increment,
  `cid` int(15) NOT NULL,
  `xp` int(15) NOT NULL,
  `year` int(4) NOT NULL,
  `month` int(2) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `cid` (`cid`,`year`,`month`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `comments`
-- 

CREATE TABLE `comments` (
  `id` int(15) NOT NULL auto_increment,
  `date` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `status` enum('public','private','system') NOT NULL default 'private',
  `character` int(15) NOT NULL,
  `parent` int(15) NOT NULL,
  `body` longtext,
  `account` int(15) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `container`
-- 

CREATE TABLE `container` (
  `id` int(15) NOT NULL auto_increment,
  `container` varchar(200) default NULL,
  `datetime` timestamp NULL default NULL on update CURRENT_TIMESTAMP,
  `character` int(15) NOT NULL,
  `resref` varchar(16) NOT NULL,
  `name` varchar(255) NOT NULL,
  `charges` int(2) NOT NULL,
  `stack` int(3) NOT NULL,
  `identified` int(1) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `container` (`container`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `craft_crafts`
-- 

CREATE TABLE `craft_crafts` (
  `id` int(15) NOT NULL auto_increment,
  `cskill` int(15) default NULL,
  `tag` varchar(16) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `craft_prod`
-- 

CREATE TABLE `craft_prod` (
  `id` int(15) NOT NULL auto_increment,
  `active` int(1) NOT NULL default '0',
  `comment` varchar(100) default 'ToDo',
  `name` varchar(200) default NULL,
  `desc` text,
  `resref` text,
  `resref_fail` text,
  `workplace` varchar(20) default NULL,
  `components` text,
  `components_save_dc` tinyint(3) NOT NULL default '12',
  `cskill` tinyint(3) unsigned default '1',
  `cskill_min` tinyint(3) unsigned default '0',
  `cskill_max` tinyint(3) unsigned default '0',
  `practical_xp_factor` float default '1',
  `ability` tinyint(3) default '3',
  `ability_dc` tinyint(3) default '10',
  `skill` tinyint(3) default '-1',
  `skill_dc` tinyint(3) default '10',
  `feat` tinyint(3) default '-1',
  `count_min` tinyint(3) default '1',
  `count_max` tinyint(3) default '1',
  `xp_cost` float default '0',
  `timespan_min` int(11) unsigned default '0',
  `lock_duration` int(5) unsigned default '0',
  `max_per_day` float unsigned default '0',
  `spell` tinyint(3) default '-1',
  `spell_fail` tinyint(3) default '-1',
  `s_craft` varchar(16) NOT NULL,
  `d_colour` varchar(12) NOT NULL default 'white',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `craft_rcpbook`
-- 

CREATE TABLE `craft_rcpbook` (
  `id` int(15) NOT NULL auto_increment,
  `character` int(15) NOT NULL,
  `cskill` int(11) NOT NULL,
  `recipe` int(15) NOT NULL,
  `ts` timestamp NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `craft_skill`
-- 

CREATE TABLE `craft_skill` (
  `id` int(15) NOT NULL auto_increment,
  `character` int(15) NOT NULL default '0',
  `cskill` int(4) NOT NULL default '0',
  `skill_theory` varchar(5) NOT NULL default '0',
  `skill_theory_xp` varchar(5) NOT NULL default '0',
  `skill_practical` varchar(5) NOT NULL default '0',
  `skill_practical_xp` varchar(5) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `craft_stat`
-- 

CREATE TABLE `craft_stat` (
  `id` int(15) NOT NULL auto_increment,
  `character` int(15) NOT NULL,
  `recipe` int(15) NOT NULL,
  `count` int(11) NOT NULL default '0',
  `fail` int(11) default '0',
  `last` int(11) default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `dms`
-- 

CREATE TABLE `dms` (
  `id` int(15) NOT NULL auto_increment,
  `account` varchar(32) NOT NULL,
  `key` varchar(8) default NULL,
  `date` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `comment` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `hidden_spawns`
-- 

CREATE TABLE `hidden_spawns` (
  `id` int(15) NOT NULL auto_increment,
  `type` varchar(32) NOT NULL,
  `resref` varchar(32) NOT NULL,
  `dc_search` int(3) default '20',
  `dc_lore` int(3) default '20',
  `search_distance` float default '6',
  `spawn_probability` int(3) default '50',
  `spawn_delay` int(11) NOT NULL default '3000',
  `max_per_area` int(11) NOT NULL default '8',
  `max_in_search_distance` int(11) NOT NULL default '4',
  `location` enum('stein','natur') default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `macro`
-- 

CREATE TABLE `macro` (
  `id` int(15) NOT NULL auto_increment,
  `account` int(15) NOT NULL,
  `ts` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `macro` varchar(200) NOT NULL,
  `command` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `mappins`
-- 

CREATE TABLE `mappins` (
  `id` bigint(20) NOT NULL auto_increment,
  `character` int(15) default NULL,
  `text` text NOT NULL,
  `x` float NOT NULL default '0',
  `y` float NOT NULL default '0',
  `area` varchar(250) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `mentordata`
-- 

CREATE TABLE `mentordata` (
  `id` int(15) NOT NULL auto_increment,
  `ts` timestamp NOT NULL default '0000-00-00 00:00:00' on update CURRENT_TIMESTAMP,
  `aid` int(15) NOT NULL,
  `cid` int(15) NOT NULL,
  `tcid` int(15) NOT NULL,
  `xp` int(10) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `mentors`
-- 

CREATE TABLE `mentors` (
  `id` int(15) NOT NULL auto_increment,
  `aid` int(15) NOT NULL,
  `last_charge_cycle` int(11) NOT NULL default '0',
  `charge` int(15) default '0',
  `charge_per_hour` int(15) default '23',
  `capacity` int(15) default '300',
  `amount_per_pc` int(30) default '30',
  `flags` int(2) default '31',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `merchant_inventory`
-- 

CREATE TABLE `merchant_inventory` (
  `id` int(11) NOT NULL auto_increment,
  `ts` timestamp NOT NULL default CURRENT_TIMESTAMP,
  `merchant` int(11) NOT NULL,
  `resref` varchar(32) NOT NULL,
  `buy` int(11) NOT NULL default '1',
  `sell` int(11) NOT NULL default '1',
  `min` int(11) NOT NULL default '0',
  `cur` int(11) unsigned NOT NULL default '0',
  `max` int(11) NOT NULL default '10',
  `buy_markup` float NOT NULL default '1',
  `sell_markdown` float NOT NULL default '1',
  `comment` varchar(255) NOT NULL default 'added by XX',
  `decay` float NOT NULL default '0',
  `last_decay` int(11) NOT NULL default '0',
  `gain` float NOT NULL default '0',
  `last_gain` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `merchant_likehate`
-- 

CREATE TABLE `merchant_likehate` (
  `id` int(11) NOT NULL auto_increment,
  `merchant` int(11) NOT NULL,
  `cid` int(11) NOT NULL,
  `mod` float NOT NULL default '1',
  `decay_per_day` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `merchants`
-- 

CREATE TABLE `merchants` (
  `id` int(11) NOT NULL auto_increment,
  `tag` varchar(128) NOT NULL,
  `money` int(11) NOT NULL default '400',
  `money_limited` int(1) NOT NULL default '1',
  `appraise_dc` int(11) NOT NULL default '10',
  `buy_markup` float NOT NULL default '1',
  `sell_markdown` float NOT NULL default '1',
  `text_intro` text NOT NULL,
  `text_buy` text NOT NULL,
  `text_sell` text NOT NULL,
  `text_nothingtobuy` text NOT NULL,
  `text_nothingtosell` text NOT NULL,
  `text_pcnomoney` text NOT NULL,
  `text_mercnomoney` text NOT NULL,
  `comment` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `online`
-- 

CREATE TABLE `online` (
  `id` int(15) NOT NULL auto_increment,
  `aid` int(15) NOT NULL,
  `cid` int(15) NOT NULL,
  `account` varchar(150) NOT NULL,
  `character` varchar(150) NOT NULL,
  `dm` int(1) NOT NULL,
  `area` varchar(150) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `f` float NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `pdata`
-- 

CREATE TABLE `pdata` (
  `id` int(15) NOT NULL auto_increment,
  `cid` int(15) NOT NULL default '0',
  `type` enum('string','int','float','location') NOT NULL,
  `key` varchar(255) default NULL,
  `value` longtext NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `persistent_effects`
-- 

CREATE TABLE `persistent_effects` (
  `id` int(15) NOT NULL auto_increment,
  `cid` int(15) default NULL,
  `when` enum('enter') NOT NULL default 'enter',
  `effect` varchar(150) NOT NULL,
  `duration_type` enum('instant','temporary','permanent') NOT NULL default 'permanent',
  `duration` float NOT NULL,
  `veffect` int(15) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `persistent_objects`
-- 

CREATE TABLE `persistent_objects` (
  `id` int(15) NOT NULL auto_increment,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `placeables`
-- 

CREATE TABLE `placeables` (
  `id` int(15) NOT NULL auto_increment,
  `resref` varchar(16) NOT NULL,
  `area` varchar(16) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `z` float NOT NULL,
  `f` float NOT NULL,
  `name` varchar(255) NOT NULL,
  `locked` int(1) NOT NULL,
  `last_access` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `lock_key` varchar(255) NOT NULL,
  `store_tag` varchar(100) NOT NULL,
  `first_placed_by` int(15) default NULL,
  `last_placed_by` int(15) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `rideables`
-- 

CREATE TABLE `rideables` (
  `id` int(15) NOT NULL auto_increment,
  `last_access` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `character` int(15) NOT NULL,
  `stable` varchar(30) default NULL,
  `type` enum('Pferd','Pony') default 'Pferd',
  `phenotype` smallint(1) default NULL,
  `name` varchar(50) default NULL,
  `delivered_in_hour` int(11) NOT NULL,
  `delivered_in_day` int(11) NOT NULL,
  `delivered_in_month` int(11) NOT NULL,
  `delivered_in_year` int(11) NOT NULL,
  `bought` tinyint(1) default '0',
  `pay_rent` int(1) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `scene_descriptions`
-- 

CREATE TABLE `scene_descriptions` (
  `id` int(15) NOT NULL auto_increment,
  `pid` int(15) NOT NULL,
  `text` text NOT NULL,
  `comment` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `sessions`
-- 

CREATE TABLE `sessions` (
  `id` int(15) NOT NULL auto_increment,
  `session_id` varchar(255) NOT NULL,
  `data` text NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `session_id` (`session_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `tab_cdkey`
-- 

CREATE TABLE `tab_cdkey` (
  `CD_Key` varchar(8) NOT NULL default '',
  `Char_Name` varchar(50) NOT NULL default '',
  `GSA_Account` varchar(50) NOT NULL default '',
  PRIMARY KEY  (`CD_Key`,`Char_Name`,`GSA_Account`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `tab_chars`
-- 

CREATE TABLE `tab_chars` (
  `Char_ID` int(8) unsigned NOT NULL auto_increment,
  `Char_Name` varchar(50) default NULL,
  `GSA_Account` varchar(50) default NULL,
  `XP` int(8) default NULL,
  `Gold` int(8) default NULL,
  `LastLogin` datetime default NULL,
  `CombatXP` int(8) default NULL,
  `CAP` int(8) default NULL,
  `Gesinnung` varchar(30) default NULL,
  `Klasse1` varchar(30) default NULL,
  `Klasse2` varchar(30) default NULL,
  `Klasse3` varchar(30) default NULL,
  `Stufe1` smallint(2) default NULL,
  `Stufe2` smallint(2) default NULL,
  `Stufe3` smallint(2) default NULL,
  `Rasse` varchar(30) default NULL,
  `SubRasse` varchar(30) default NULL,
  `Gottheit` varchar(30) default NULL,
  `elfen_keystone` enum('TRUE','FALSE') NOT NULL default 'FALSE',
  `zwerg_keystone` enum('TRUE','FALSE') NOT NULL default 'FALSE',
  `druiden_keystone` enum('TRUE','FALSE') NOT NULL default 'FALSE',
  `boese_keystone` enum('TRUE','FALSE') NOT NULL default 'FALSE',
  `monk_keystone` enum('TRUE','FALSE') NOT NULL default 'FALSE',
  `AreaTag` varchar(30) default NULL,
  `X` float default NULL,
  `Y` float default NULL,
  `Z` float default NULL,
  `Richtung` float default NULL,
  PRIMARY KEY  (`Char_ID`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `tab_pferde`
-- 

CREATE TABLE `tab_pferde` (
  `id` int(15) NOT NULL auto_increment,
  `character` int(15) NOT NULL,
  `Stall` varchar(30) default NULL,
  `Art` enum('Pferd','Pony') default 'Pferd',
  `Phenotype` smallint(1) default NULL,
  `Name` varchar(50) default NULL,
  `last_month_paid` int(11) NOT NULL default '0',
  `bought` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `tab_ressourcen`
-- 

CREATE TABLE `tab_ressourcen` (
  `spawn_id` int(8) NOT NULL auto_increment,
  `Name` varchar(20) default NULL,
  `Typ` varchar(20) default NULL,
  `ResRef` varchar(16) default NULL,
  `SG` int(3) default NULL,
  `Value` int(3) default NULL,
  `Bonus` varchar(10) default NULL,
  PRIMARY KEY  (`spawn_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `telepathic_bonds`
-- 

CREATE TABLE `telepathic_bonds` (
  `id` int(15) NOT NULL auto_increment,
  `cid` int(15) NOT NULL,
  `tcid` int(15) NOT NULL,
  `ts` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `active` int(1) default '1',
  `expire` int(11) default NULL,
  `shortname` varchar(128) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `time_xp`
-- 

CREATE TABLE `time_xp` (
  `id` int(15) NOT NULL auto_increment,
  `cid` int(15) NOT NULL,
  `xp` int(15) NOT NULL,
  `year` int(4) NOT NULL,
  `month` int(2) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `cid` (`cid`,`year`,`month`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `tracks`
-- 

CREATE TABLE `tracks` (
  `id` int(15) NOT NULL auto_increment,
  `cid` int(11) NOT NULL,
  `area` varchar(16) NOT NULL,
  `x` float NOT NULL,
  `y` float NOT NULL,
  `facing` float NOT NULL,
  `age` int(11) NOT NULL,
  `deep` int(11) NOT NULL,
  `size` int(11) NOT NULL,
  `gender` int(11) NOT NULL,
  `speed` int(11) NOT NULL,
  `barefoot` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `var`
-- 

CREATE TABLE `var` (
  `id` int(15) NOT NULL auto_increment,
  `character` int(15) NOT NULL,
  `type` enum('string','int','float','location','vector') NOT NULL default 'string',
  `name` text NOT NULL,
  `value` text NOT NULL,
  `expire_at` datetime NOT NULL,
  `last_access` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `weather`
-- 

CREATE TABLE `weather` (
  `id` int(15) NOT NULL auto_increment,
  `wlast` int(11) NOT NULL,
  `wthis` int(11) NOT NULL,
  `wvthis` int(11) NOT NULL,
  `year` int(4) NOT NULL,
  `month` int(2) NOT NULL,
  `day` int(2) NOT NULL,
  `hour` int(2) NOT NULL,
  `textkey` int(11) NOT NULL default '0',
  `fogv` int(11) NOT NULL default '0',
  `fogc` int(11) NOT NULL,
  `engine` enum('clear','rain','snow') NOT NULL default 'clear',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

-- 
-- Table structure for table `weather_overrides`
-- 

CREATE TABLE `weather_overrides` (
  `id` int(15) NOT NULL auto_increment,
  `aid` int(15) NOT NULL,
  `atype` varchar(10) NOT NULL,
  `ayear` int(11) NOT NULL,
  `amonth` int(11) NOT NULL,
  `aday` int(11) NOT NULL,
  `zyear` int(11) NOT NULL,
  `zmonth` int(11) NOT NULL,
  `zday` int(11) NOT NULL,
  `temp` int(11) NOT NULL,
  `wind` int(11) NOT NULL,
  `prec` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1;


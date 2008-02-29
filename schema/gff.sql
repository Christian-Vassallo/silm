create domain gff as bytea;
create schema gff;


create function gff._gff_get_field_value(text,varchar) returns varchar as $_$
	use MIME::Base64;
	use GffRead;
	
	my ($data, $field) = ($_[0], $_[1]);
	$data = decode_base64($data);

	my $gff = GffRead::read(data => $data);
	return $gff->get_or_set($field);
$_$ language plperlu;

create function gff._gff_set_field_value(text,varchar,varchar) returns text as $_$
	use MIME::Base64;
	use GffRead;
	use GffWrite;
	my ($data, $field, $value) = ($_[0], $_[1], $_[2]);
	my $gff = GffRead::read(data => decode_base64($data));

	$gff->get_or_set($field, $value);

	return encode_base64(GffWrite::write($gff));
$_$ language plperlu;

create function gff._gff_set_field_value(text,varchar,varchar,int) returns text as $_$
	use MIME::Base64;
	use GffRead;
	use GffWrite;
	my ($data, $field, $value, $type) = ($_[0], $_[1], $_[2], $_[3]);
	my $gff = GffRead::read(data => decode_base64($data));

	$gff->get_or_set($field, $value, $type);

	return encode_base64(GffWrite::write($gff));
$_$ language plperlu;


create function gff.value(gff,varchar) returns varchar as $_$
	select gff._gff_get_field_value(encode($1, 'base64'), $2);
$_$ language sql;

create function gff.value(gff,varchar,varchar) returns gff as $_$
	select decode(gff._gff_set_field_value( encode($1, 'base64'), $2, $3), 'base64')::gff;
$_$ language sql;

create function gff.value(gff,varchar,varchar,int) returns gff as $_$
	select decode(gff._gff_set_field_value( encode($1, 'base64'), $2, $3), 'base64')::gff;
$_$ language sql;

-- todo:
-- $gff ->
--  type([type)
--  variable(name, [value, type of (int float string object location)) 
--      create type gff.variable_type as enum('string', 'int', 'float', 'object', 'location');
--      create type gff.variable as (name varchar, value varchar, type variable_type);
--  find et al

-- select
--	gff.value( gff.value((select data from test limit 1), '/LocalizedName/4', 'test'), '/LocalizedName/4');

create function gff.gfftotext(varchar,bytea) returns text as 'net.swordcoast.sternenfall.ConvertShit.gffToXml(java.lang.String,byte[])' language javau;
create function gff.texttogff(varchar,boolean) returns bytea as 'net.swordcoast.sternenfall.ConvertShit.XmlToGff(java.lang.String,boolean)' language javau;
create function gff.toxml(name varchar,gff gff) returns xml as 'select gff.gfftotext($1, $2::bytea)::xml;' language sql;
create function gff.toxml(gff gff) returns xml as $_$select gff.gfftotext(gff.value($1, '/TemplateResRef' ), $1::bytea)::xml;$_$ language sql;
create function gff.togff(xml,compression boolean) returns gff as 'select gff.texttogff($1::varchar, $2)::gff;' language sql;
create function gff.togff(xml) returns gff as 'select gff.texttogff($1::varchar, false)::gff;' language sql;


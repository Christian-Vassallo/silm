create schema plgff;

create function plgff._gff_get_field_value(text,varchar) returns varchar as $_$
	use MIME::Base64;
	use GffRead;
	
	my ($data, $field) = ($_[0], $_[1]);
	$data = decode_base64($data);

	my $gff = GffRead::read(data => $data);
	return $gff->get_or_set($field);
$_$ language plperlu;

create function plgff._gff_set_field_value(text,varchar,varchar) returns text as $_$
	use MIME::Base64;
	use GffRead;
	use GffWrite;
	my ($data, $field, $value) = ($_[0], $_[1], $_[2]);
	my $gff = GffRead::read(data => decode_base64($data));

	$gff->get_or_set($field, $value);

	return encode_base64(GffWrite::write($gff));
$_$ language plperlu;

create function plgff._gff_set_field_value(text,varchar,varchar,int) returns text as $_$
	use MIME::Base64;
	use GffRead;
	use GffWrite;
	my ($data, $field, $value, $type) = ($_[0], $_[1], $_[2], $_[3]);
	my $gff = GffRead::read(data => decode_base64($data));

	$gff->get_or_set($field, $value, $type);

	return encode_base64(GffWrite::write($gff));
$_$ language plperlu;


create function plgff.value(bytea,varchar) returns varchar as $_$
	select plgff._gff_get_field_value(encode($1, 'base64'), $2);
$_$ language sql;

create function plgff.value(bytea,varchar,varchar) returns bytea as $_$
	select decode(plgff._gff_set_field_value( encode($1, 'base64'), $2, $3), 'base64');
$_$ language sql;

create function plgff.value(bytea,varchar,varchar,int) returns bytea as $_$
	select decode(plgff._gff_set_field_value( encode($1, 'base64'), $2, $3), 'base64');
$_$ language sql;

-- todo:
-- $gff ->
--  type([type)
--  variable(name, [value, type of (int float string object location)) 
--      create type plgff.variable_type as enum('string', 'int', 'float', 'object', 'location');
--      create type plgff.variable as (name varchar, value varchar, type variable_type);
--  find et al

-- select
--	plgff.value( plgff.value((select data from test limit 1), '/LocalizedName/4', 'test'), '/LocalizedName/4');

select sqlj.install_jar('file:/home/silm/sqlgffxml.jar', 'sqlgffxml', true);
select sqlj.install_jar('file:/home/silm/nwn-tools.jar', 'nwntools', true);
select sqlj.install_jar('file:/home/silm/log4j.jar', 'log4j', true);
select sqlj.install_jar('file:/home/silm/meta-jb-util.jar', 'm1', true);
select sqlj.install_jar('file:/home/silm/meta-jb-xml.jar', 'm2', true);
select sqlj.set_classpath('public', 'sqlgffxml:nwntools:log4j:m1:m2');
create schema gff;
create domain gff_data as bytea;
create function gff.gfftotext(varchar,bytea) returns text as 'net.swordcoast.sternenfall.ConvertShit.gffToXml(java.lang.String,byte[])' language javau;
create function gff.texttogff(varchar,boolean) returns bytea as 'net.swordcoast.sternenfall.ConvertShit.XmlToGff(java.lang.String,boolean)' language javau;

create function gff.toxml(name varchar,gff gff_data) returns xml as 'select gff.gfftotext($1, $2::bytea)::xml;' language sql;
create function gff.togff(xml,compression boolean) returns gff_data as 'select gff.texttogff($1::varchar, $2)::gff_data;' language sql;

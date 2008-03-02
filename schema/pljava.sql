select sqlj.install_jar('file:/home/silm/sqlgffxml.jar', 'sqlgffxml', true);
select sqlj.install_jar('file:/home/silm/log4j.jar', 'log4j', true);
select sqlj.install_jar('file:/home/silm/meta-jb-util.jar', 'metajbutil', true);
select sqlj.install_jar('file:/home/silm/meta-jb-xml.jar', 'metajbxml', true);
select sqlj.set_classpath('public', 'sqlgffxml:log4j:metajbutil:metajbxml');

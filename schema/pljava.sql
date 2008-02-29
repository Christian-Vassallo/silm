select sqlj.install_jar('file:/home/silm/sqlgffxml.jar', 'sqlgffxml', true);
select sqlj.install_jar('file:/home/silm/nwn-tools.jar', 'nwntools', true);
select sqlj.install_jar('file:/home/silm/log4j.jar', 'log4j', true);
select sqlj.install_jar('file:/home/silm/meta-jb-util.jar', 'm1', true);
select sqlj.install_jar('file:/home/silm/meta-jb-xml.jar', 'm2', true);
select sqlj.set_classpath('public', 'sqlgffxml:nwntools:log4j:m1:m2');

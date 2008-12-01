use ExtUtils::MakeMaker;

WriteMakefile(
	'NAME'		=> 'xndiff',
	'VERSION'	=> '0.1',
	'EXE_FILES'	=> [ 'xndiff' ],
	'PREREQ_PM'	=> { 'Nmap::Parser' },
	'PREFIX'	=> '/usr/local',
    );

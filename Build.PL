use Module::Build;

my $build = Module::Build->new (
    dist_abstract      => 'find differences between two nmap network scans',
    dist_author        => 'http://code.google.com/p/yandiff',
    dist_name          => 'yandiff',
    dist_version_from  => 'bin/yandiff',
    license            => 'bsd',
    requires           => {
        'Nmap::Parser' => 0,
    },
 );
$build->create_build_script;

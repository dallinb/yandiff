use File::Spec;
use Test::Simple tests => 5;
 
# See if we can locate the script.
my $script = File::Spec->catpath('', 'bin', 'xndiff');
ok( -f $script, 'Located script OK');

# See if we can located the test input file.
my $file = File::Spec->catpath("", 't', 'oA9.xml');
ok( -f $file, 'Located test XML OK');

# Do a trial run of the script
my $perl_interpreter = "$^X ";
my $command_line = "$^X $script --baseline $file --observed $file";
my $command_output = `$command_line`;
ok($? == 0, 'Script returned zero status.');

# Check the correct number of lines were returned from the script.
my @lines = split /^/m, $command_output;
chomp @lines;
ok($#lines == 9, 'Number of output lines from script');

# Check the content returned.
my $last_line = $lines[9];
ok( $last_line eq "Changed hosts:" , 'Content test');

##############################################################################
# Copyright (c) 2008-2009, League of Crafty Programmers Ltd <info@locp.co.uk>
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#   * Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#   * Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY LEAGUE OF CRAFTY PROGRAMMERS ''AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL LEAGUE OF CRAFTY PROGRAMMERS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
##############################################################################
use Data::Dumper;
use File::Spec;
use Test::Simple tests => 27;
use XML::Parser;
use strict;

use t::testgen;
 
# See if we can locate the script.
my $script = File::Spec->catpath('', 'bin', 'yandiff');
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

# Now start testing the XML generated.  The following tests basically test
# the output according to:
#   http://code.google.com/p/yandiff/wiki/FunctionalTestTemplate
my $baseline = File::Spec->catpath("", 't', 'baseline_qa.xml');
my $observed = File::Spec->catpath("", 't', 'observed_qa.xml');
$command_line = "$^X $script --baseline $baseline --observed $observed"
    . " --format xml";
$command_output = `$command_line`;
my $syntax_check = 0;
my $stage = 'QA Test 1.1';
my $tree;
$syntax_check = 1 if (!$command_output);
my $parser = new XML::Parser(Style => 'Tree');

# We enclose the parse function within the eval so that we can catch parse
# error exceptions.  Otherwise we're not notified of syntax errors.
eval {
	$tree = $parser->parse($command_output);
};

$syntax_check = 1 if ($@);
ok($syntax_check == 0, "Produces valid XML");

# Now check the contents of specific fields.
$syntax_check = 0;
$syntax_check = 1 if ($tree->[0] ne 'yandiff');
$syntax_check = 1 if ($tree->[1]->[3] ne 'parameters');
$syntax_check = 1 if ($tree->[1]->[4]->[0]->{node_key} ne 'IP');
$syntax_check = 1 if ($tree->[1]->[4]->[3] ne 'baseline');
$syntax_check = 1 if ($tree->[1]->[4]->[4]->[3] ne 'file');
$syntax_check = 1 if ($tree->[1]->[4]->[4]->[4]->[2] ne $baseline);
$syntax_check = 1 if ($tree->[1]->[4]->[7] ne 'observed');
$syntax_check = 1 if ($tree->[1]->[4]->[8]->[4]->[2] ne $observed);
ok($syntax_check == 0, "Syntax Test ($stage)");

$syntax_check = 0;
$stage = 'QA Test 1.2';
$syntax_check = 1 if ($tree->[1]->[7] ne 'new');
$syntax_check = 1 if ($tree->[1]->[8]->[3] ne 'host');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{hostname}
    ne 'charlie.example.com');
$syntax_check = 1 if ($tree->[1]->[11] ne 'missing');
$syntax_check = 1 if ($tree->[1]->[12]->[3] ne 'host');
$syntax_check = 1 if ($tree->[1]->[12]->[4]->[0]->{hostname}
    ne 'alpha.example.com');
$syntax_check = 1 if ($tree->[1]->[15] ne 'changed');
$syntax_check = 1 if ($tree->[1]->[16]->[3] ne 'host');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[0]->{hostname}
    ne 'bravo.example.com');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[3] ne 'new_services');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[3] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[4]->[0]->{portid} ne '8');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[4]->[0]->{proto} ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[4]->[0]->{status}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[8]->[0]->{portid} ne '9');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[8]->[0]->{proto} ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[8]->[0]->{status}
    ne 'closed');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[11] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[12]->[0]->{portid}
    ne '10');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[12]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[12]->[0]->{status}
    ne 'filtered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[15] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[16]->[0]->{portid}
    ne '11');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[16]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[16]->[0]->{status}
    ne 'unfiltered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[19] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[20]->[0]->{portid}
    ne '12');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[20]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[20]->[0]->{status}
    ne 'open|filtered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[23] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[24]->[0]->{portid}
    ne '13');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[24]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[24]->[0]->{status}
    ne 'closed|filtered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[27] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[28]->[0]->{portid} ne '8');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[28]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[28]->[0]->{status}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[31] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[32]->[0]->{portid} ne '9');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[32]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[32]->[0]->{status}
    ne 'closed');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[35] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[36]->[0]->{portid}
    ne '10');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[36]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[36]->[0]->{status}
    ne 'filtered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[39] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[40]->[0]->{portid}
    ne '11');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[40]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[40]->[0]->{status}
    ne 'unfiltered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[43] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[44]->[0]->{portid}
    ne '12');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[44]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[44]->[0]->{status}
    ne 'open|filtered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[47] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[48]->[0]->{portid}
    ne '13');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[48]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[48]->[0]->{status}
    ne 'closed|filtered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[7] ne 'missing_services');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[8]->[3] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[8]->[4]->[0]->{portid} ne '1');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[8]->[4]->[0]->{proto} ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[8]->[4]->[0]->{status}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[8]->[7] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[8]->[8]->[0]->{portid} ne '1');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[8]->[8]->[0]->{proto} ne 'udp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[8]->[8]->[0]->{status}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[11] ne 'changed_services');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[3] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[4]->[0]->{portid} ne '3');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[4]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[4]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[4]->[0]->{status}
    ne 'closed');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[7] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[8]->[0]->{portid} ne '4');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[8]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[8]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[8]->[0]->{status}
    ne 'filtered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[11] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[12]->[0]->{portid}
    ne '5');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[12]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[12]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[12]->[0]->{status}
    ne 'unfiltered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[15] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[16]->[0]->{portid}
    ne '6');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[16]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[16]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[16]->[0]->{status}
    ne 'open|filtered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[19] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[20]->[0]->{portid}
    ne '7');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[20]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[20]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[20]->[0]->{status}
    ne 'closed|filtered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[23] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[24]->[0]->{portid}
    ne '14');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[24]->[0]->{previous}
    ne 'unfiltered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[24]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[24]->[0]->{status}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[28]->[0]->{portid}
    ne '3');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[28]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[28]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[28]->[0]->{status}
    ne 'closed');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[31] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[32]->[0]->{portid}
    ne '4');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[32]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[32]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[32]->[0]->{status}
    ne 'filtered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[35] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[36]->[0]->{portid}
    ne '5');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[36]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[36]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[36]->[0]->{status}
    ne 'unfiltered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[39] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[40]->[0]->{portid}
    ne '6');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[40]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[40]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[40]->[0]->{status}
    ne 'open|filtered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[43] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[44]->[0]->{portid}
    ne '7');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[44]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[44]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[44]->[0]->{status}
    ne 'closed|filtered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[47] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[48]->[0]->{portid}
    ne '14');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[48]->[0]->{previous}
    ne 'unfiltered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[48]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[48]->[0]->{status}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[17] ne '0');
ok($syntax_check == 0, "Syntax Test ($stage)");

$syntax_check = 0;
$stage = 'QA Test 2';
$command_line = "$^X $script --baseline $baseline --observed $observed"
    . " --format xml --output-hosts n";
$command_output = `$command_line`;
$syntax_check = 1 if (!$command_output);
$parser = new XML::Parser(Style => 'Tree');

eval {
	$tree = $parser->parse($command_output);
};

$syntax_check = 1 if ($@);
$syntax_check = 1 if ($tree->[1]->[7] ne 'new');
$syntax_check = 1 if ($tree->[1]->[8]->[3] ne 'host');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{hostname}
    ne 'charlie.example.com');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{ip_addr}
    ne '192.168.1.24');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{mac_addr}
    ne '00:1E:4F:09:96:5D');
$syntax_check = 1 if ($tree->[1]->[9] ne '0');
ok($syntax_check == 0, "Syntax Test ($stage)");

$command_line = "$^X $script --baseline $baseline --observed $observed"
    . " --format xml --output-hosts c";
$command_output = `$command_line`;
$syntax_check = 1 if (!$command_output);
$parser = new XML::Parser(Style => 'Tree');

eval {
	$tree = $parser->parse($command_output);
};

$syntax_check = 1 if ($@);
$stage = 'QA Test 3';
$syntax_check = 1 if ($tree->[1]->[8]->[3] ne 'host');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{hostname}
    ne 'bravo.example.com');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{ip_addr}
    ne '192.168.1.16');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{mac_addr}
    ne '00:1E:4F:33:35:D4');
$syntax_check = 1 if ($tree->[1]->[9] ne '0');
ok($syntax_check == 0, "Syntax Test ($stage)");

$stage = 'QA Test 4';
$syntax_check = 0;
$command_line = "$^X $script --baseline $baseline --observed $observed"
    . " --format xml --output-hosts m";
$command_output = `$command_line`;
$syntax_check = 1 if (!$command_output);
$parser = new XML::Parser(Style => 'Tree');

eval {
	$tree = $parser->parse($command_output);
};

$syntax_check = 1 if ($@);
$syntax_check = 1 if ($tree->[1]->[7] ne 'missing');
$syntax_check = 1 if ($tree->[1]->[8]->[3] ne 'host');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{hostname}
    ne 'alpha.example.com');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{ip_addr} ne '192.168.1.8');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{mac_addr}
    ne '00:1E:4F:09:96:5D');
$syntax_check = 1 if ($tree->[1]->[9] ne '0');
ok($syntax_check == 0, "Syntax Test ($stage)");

$stage = 'QA Test 5';
$syntax_check = 0;
$command_line = "$^X $script --baseline $baseline --observed $observed"
    . " --format xml --output-hosts c --output-ports o";
$command_output = `$command_line`;
$syntax_check = 1 if (!$command_output);
$parser = new XML::Parser(Style => 'Tree');

eval {
	$tree = $parser->parse($command_output);
};

$syntax_check = 1 if ($@);
$syntax_check = 1 if ($tree->[1]->[7] ne 'changed');
$syntax_check = 1 if ($tree->[1]->[8]->[3] ne 'host');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{hostname}
    ne 'bravo.example.com');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{ip_addr}
    ne '192.168.1.16');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{mac_addr}
    ne '00:1E:4F:33:35:D4');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[3] ne 'new_services');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[3] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[4]->[0]->{portid} ne '8');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[4]->[0]->{proto} ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[4]->[0]->{status}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[7] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[8]->[0]->{portid} ne '12');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[8]->[0]->{proto} ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[8]->[0]->{status}
    ne 'open|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[11] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[12]->[0]->{portid} ne '8');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[12]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[12]->[0]->{status}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[15] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[16]->[0]->{portid}
    ne '12');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[16]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[16]->[0]->{status}
    ne 'open|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[7] ne 'missing_services');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[11] ne 'changed_services');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[3] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{portid} ne '6');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{status}
    ne 'open|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[7] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{portid}
    ne '14');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{previous}
    ne 'unfiltered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{status}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[11] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{portid}
    ne '6');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{status}
    ne 'open|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[15] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{portid}
    ne '14');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{previous}
    ne 'unfiltered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{status}
    ne 'open');
ok($syntax_check == 0, "Syntax Test ($stage)");

$stage = 'QA Test 6';
$syntax_check = 0;
$command_line = "$^X $script --baseline $baseline --observed $observed"
    . " --format xml --output-hosts c --output-ports f";
$command_output = `$command_line`;
$syntax_check = 1 if (!$command_output);
$parser = new XML::Parser(Style => 'Tree');

eval {
	$tree = $parser->parse($command_output);
};

$syntax_check = 1 if ($@);
$syntax_check = 1 if ($tree->[1]->[7] ne 'changed');
$syntax_check = 1 if ($tree->[1]->[8]->[3] ne 'host');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{hostname}
    ne 'bravo.example.com');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{ip_addr}
    ne '192.168.1.16');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{mac_addr}
    ne '00:1E:4F:33:35:D4');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[3] ne 'new_services');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[3] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[4]->[0]->{portid} ne '10');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[4]->[0]->{proto} ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[4]->[0]->{status}
    ne 'filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[7] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[8]->[0]->{portid} ne '12');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[8]->[0]->{proto} ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[8]->[0]->{status}
    ne 'open|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[11] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[12]->[0]->{portid}
    ne '13');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[12]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[12]->[0]->{status}
    ne 'closed|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[15] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[16]->[0]->{portid}
    ne '10');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[16]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[16]->[0]->{status}
    ne 'filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[19] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[20]->[0]->{portid}
    ne '12');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[20]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[20]->[0]->{status}
    ne 'open|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[23] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[24]->[0]->{portid}
    ne '13');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[24]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[24]->[0]->{status}
    ne 'closed|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[7] ne 'missing_services');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[11] ne 'changed_services');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[3] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{portid} ne '4');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{status}
    ne 'filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[7] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{portid} ne '6');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{status}
    ne 'open|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[11] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{portid}
    ne '7');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{status}
    ne 'closed|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[15] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{portid}
    ne '4');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{status}
    ne 'filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[19] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[20]->[0]->{portid}
    ne '6');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[20]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[20]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[20]->[0]->{status}
    ne 'open|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[23] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[24]->[0]->{portid}
    ne '7');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[24]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[24]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[24]->[0]->{status}
    ne 'closed|filtered');
ok($syntax_check == 0, "Syntax Test ($stage)");

$stage = 'QA Test 7';
$syntax_check = 0;
$command_line = "$^X $script --baseline $baseline --observed $observed"
    . " --format xml --output-hosts c --output-ports c";
$command_output = `$command_line`;
$syntax_check = 1 if (!$command_output);
$parser = new XML::Parser(Style => 'Tree');

eval {
	$tree = $parser->parse($command_output);
};

$syntax_check = 1 if ($@);
$syntax_check = 1 if ($tree->[1]->[7] ne 'changed');
$syntax_check = 1 if ($tree->[1]->[8]->[3] ne 'host');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{hostname}
    ne 'bravo.example.com');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{ip_addr}
    ne '192.168.1.16');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{mac_addr}
    ne '00:1E:4F:33:35:D4');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[3] ne 'new_services');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[7] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[8]->[0]->{portid} ne '13');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[8]->[0]->{proto} ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[8]->[0]->{status}
    ne 'closed|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[11] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[12]->[0]->{portid} ne '9');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[12]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[12]->[0]->{status}
    ne 'closed');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[15] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[16]->[0]->{portid}
    ne '13');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[16]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[16]->[0]->{status}
    ne 'closed|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[7] ne 'missing_services');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[11] ne 'changed_services');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[3] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{portid} ne '3');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{status}
    ne 'closed');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[7] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{portid} ne '7');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{status}
    ne 'closed|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[11] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{portid}
    ne '3');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{status}
    ne 'closed');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[15] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{portid}
    ne '7');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{status}
    ne 'closed|filtered');

ok($syntax_check == 0, "Syntax Test ($stage)");

$stage = 'QA Test 8';
$syntax_check = 0;
$command_line = "$^X $script --baseline $baseline --observed $observed"
    . " --format xml --output-hosts c --output-ports c";
$command_output = `$command_line`;
$syntax_check = 1 if (!$command_output);
$parser = new XML::Parser(Style => 'Tree');

eval {
	$tree = $parser->parse($command_output);
};

$syntax_check = 1 if ($@);
$syntax_check = 1 if ($tree->[1]->[7] ne 'changed');
$syntax_check = 1 if ($tree->[1]->[8]->[3] ne 'host');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{hostname}
    ne 'bravo.example.com');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{ip_addr}
    ne '192.168.1.16');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{mac_addr}
    ne '00:1E:4F:33:35:D4');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{status} ne 'up');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[3] ne 'new_services');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[3] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[4]->[0]->{portid} ne '9');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[4]->[0]->{proto} ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[4]->[0]->{status}
    ne 'closed');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[7] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[8]->[0]->{portid} ne '13');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[8]->[0]->{proto} ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[8]->[0]->{status}
    ne 'closed|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[11] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[12]->[0]->{portid} ne '9');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[12]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[12]->[0]->{status}
    ne 'closed');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[15] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[16]->[0]->{portid}
    ne '13');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[16]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[16]->[0]->{status}
    ne 'closed|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[7] ne 'missing_services');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[11] ne 'changed_services');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[3] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{portid} ne '3');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{status}
    ne 'closed');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[7] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{portid} ne '7');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{status}
    ne 'closed|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[11] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{portid}
    ne '3');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{status}
    ne 'closed');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[15] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{portid}
    ne '7');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{status}
    ne 'closed|filtered');
ok($syntax_check == 0, "Syntax Test ($stage)");

$baseline = File::Spec->catpath("", 't', 'baseline_qa.xml');
$observed = File::Spec->catpath("", 't', 'dns3.xml');
$command_line = "$^X $script --baseline $baseline --observed $observed"
    . " --format xml --hk";
$command_output = `$command_line`;
$syntax_check = 0;
$stage = 'QA Test 9';
$syntax_check = 1 if (!$command_output);
$parser = new XML::Parser(Style => 'Tree');

eval {
	$tree = $parser->parse($command_output);
};

$syntax_check = 1 if ($@);

$syntax_check = 0;
$syntax_check = 1 if ($tree->[0] ne 'yandiff');
$syntax_check = 1 if ($tree->[1]->[3] ne 'parameters');
$syntax_check = 1 if ($tree->[1]->[4]->[0]->{node_key} ne 'Hostname');
$syntax_check = 1 if ($tree->[1]->[4]->[3] ne 'baseline');
$syntax_check = 1 if ($tree->[1]->[4]->[4]->[3] ne 'file');
$syntax_check = 1 if ($tree->[1]->[4]->[4]->[4]->[2] ne $baseline);
$syntax_check = 1 if ($tree->[1]->[4]->[7] ne 'observed');
$syntax_check = 1 if ($tree->[1]->[4]->[8]->[4]->[2] ne $observed);
$syntax_check = 1 if ($tree->[1]->[7] ne 'new');
$syntax_check = 1 if ($tree->[1]->[8]->[3] ne 'host');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{hostname}
    ne 'charlie.example.com');
$syntax_check = 1 if ($tree->[1]->[11] ne 'missing');
$syntax_check = 1 if ($tree->[1]->[12]->[3] ne 'host');
$syntax_check = 1 if ($tree->[1]->[12]->[4]->[0]->{hostname}
    ne 'alpha.example.com');
$syntax_check = 1 if ($tree->[1]->[15] ne 'changed');
$syntax_check = 1 if ($tree->[1]->[16]->[3] ne 'host');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[0]->{hostname}
    ne 'bravo.example.com');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[3] ne 'new_services');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[3] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[4]->[0]->{portid} ne '8');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[4]->[0]->{proto} ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[4]->[0]->{status}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[8]->[0]->{portid} ne '9');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[8]->[0]->{proto} ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[8]->[0]->{status}
    ne 'closed');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[11] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[12]->[0]->{portid} ne '10');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[12]->[0]->{proto} ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[12]->[0]->{status}
    ne 'filtered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[15] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[16]->[0]->{portid}
    ne '11');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[16]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[16]->[0]->{status}
    ne 'unfiltered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[19] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[20]->[0]->{portid}
    ne '12');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[20]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[20]->[0]->{status}
    ne 'open|filtered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[23] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[24]->[0]->{portid}
    ne '13');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[24]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[24]->[0]->{status}
    ne 'closed|filtered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[27] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[28]->[0]->{portid} ne '8');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[28]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[28]->[0]->{status}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[31] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[32]->[0]->{portid} ne '9');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[32]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[32]->[0]->{status}
    ne 'closed');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[35] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[36]->[0]->{portid}
    ne '10');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[36]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[36]->[0]->{status}
    ne 'filtered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[39] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[40]->[0]->{portid}
    ne '11');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[40]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[40]->[0]->{status}
    ne 'unfiltered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[43] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[44]->[0]->{portid}
    ne '12');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[44]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[44]->[0]->{status}
    ne 'open|filtered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[47] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[48]->[0]->{portid}
    ne '13');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[48]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[4]->[48]->[0]->{status}
    ne 'closed|filtered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[7] ne 'missing_services');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[8]->[3] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[8]->[4]->[0]->{portid} ne '1');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[8]->[4]->[0]->{proto} ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[8]->[4]->[0]->{status}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[8]->[7] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[8]->[8]->[0]->{portid} ne '1');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[8]->[8]->[0]->{proto} ne 'udp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[8]->[8]->[0]->{status}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[11] ne 'changed_services');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[3] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[4]->[0]->{portid} ne '3');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[4]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[4]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[4]->[0]->{status}
    ne 'closed');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[7] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[8]->[0]->{portid} ne '4');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[8]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[8]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[8]->[0]->{status}
    ne 'filtered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[11] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[12]->[0]->{portid}
    ne '5');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[12]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[12]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[12]->[0]->{status}
    ne 'unfiltered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[15] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[16]->[0]->{portid}
    ne '6');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[16]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[16]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[16]->[0]->{status}
    ne 'open|filtered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[19] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[20]->[0]->{portid}
    ne '7');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[20]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[20]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[20]->[0]->{status}
    ne 'closed|filtered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[23] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[24]->[0]->{portid}
    ne '14');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[24]->[0]->{previous}
    ne 'unfiltered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[24]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[24]->[0]->{status}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[28]->[0]->{portid}
    ne '3');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[28]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[28]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[28]->[0]->{status}
    ne 'closed');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[31] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[32]->[0]->{portid}
    ne '4');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[32]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[32]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[32]->[0]->{status}
    ne 'filtered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[35] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[36]->[0]->{portid}
    ne '5');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[36]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[36]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[36]->[0]->{status}
    ne 'unfiltered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[39] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[40]->[0]->{portid}
    ne '6');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[40]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[40]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[40]->[0]->{status}
    ne 'open|filtered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[43] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[44]->[0]->{portid}
    ne '7');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[44]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[44]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[44]->[0]->{status}
    ne 'closed|filtered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[47] ne 'service');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[48]->[0]->{portid}
    ne '14');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[48]->[0]->{previous}
    ne 'unfiltered');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[48]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[12]->[48]->[0]->{status}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[17] ne '0');
ok($syntax_check == 0, "Syntax Test ($stage)");

$syntax_check = 0;
$stage = 'QA Test 10';
$command_line = "$^X $script --baseline $baseline --observed $observed"
    . " --format xml --output-hosts n --hk";
$command_output = `$command_line`;
$syntax_check = 1 if (!$command_output);
$parser = new XML::Parser(Style => 'Tree');

eval {
	$tree = $parser->parse($command_output);
};

$syntax_check = 1 if ($@);
$syntax_check = 1 if ($tree->[1]->[7] ne 'new');
$syntax_check = 1 if ($tree->[1]->[8]->[3] ne 'host');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{hostname}
    ne 'charlie.example.com');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{ip_addr}
    ne '192.168.1.25');
ok($syntax_check == 0, "Syntax Test ($stage)");
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{mac_addr}
    ne '00:1E:4F:09:96:5D');
$syntax_check = 1 if ($tree->[1]->[9] ne '0');

$command_line = "$^X $script --baseline $baseline --observed $observed"
    . " --format xml --output-hosts c --hk";
$command_output = `$command_line`;
$syntax_check = 1 if (!$command_output);
$parser = new XML::Parser(Style => 'Tree');

eval {
	$tree = $parser->parse($command_output);
};

$syntax_check = 1 if ($@);
$stage = 'QA Test 11';
$syntax_check = 1 if ($tree->[1]->[8]->[3] ne 'host');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{hostname}
    ne 'bravo.example.com');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{ip_addr}
    ne '192.168.1.17');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{mac_addr}
    ne '00:1E:4F:33:35:D4');
$syntax_check = 1 if ($tree->[1]->[9] ne '0');
ok($syntax_check == 0, "Syntax Test ($stage)");

$stage = 'QA Test 12';
$syntax_check = 0;
$command_line = "$^X $script --baseline $baseline --observed $observed"
    . " --format xml --output-hosts m --hk";
$command_output = `$command_line`;
$syntax_check = 1 if (!$command_output);
$parser = new XML::Parser(Style => 'Tree');

eval {
	$tree = $parser->parse($command_output);
};

$syntax_check = 1 if ($@);
$syntax_check = 1 if ($tree->[1]->[7] ne 'missing');
$syntax_check = 1 if ($tree->[1]->[8]->[3] ne 'host');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{hostname}
    ne 'alpha.example.com');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{ip_addr} ne '192.168.1.8');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{mac_addr}
    ne '00:1E:4F:09:96:5D');
$syntax_check = 1 if ($tree->[1]->[9] ne '0');
ok($syntax_check == 0, "Syntax Test ($stage)");

$stage = 'QA Test 13';
$syntax_check = 0;
$command_line = "$^X $script --baseline $baseline --observed $observed"
    . " --format xml --output-hosts c --output-ports o --hk";
$command_output = `$command_line`;
$syntax_check = 1 if (!$command_output);
$parser = new XML::Parser(Style => 'Tree');

eval {
	$tree = $parser->parse($command_output);
};

$syntax_check = 1 if ($@);
$syntax_check = 1 if ($tree->[1]->[7] ne 'changed');
$syntax_check = 1 if ($tree->[1]->[8]->[3] ne 'host');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{hostname}
    ne 'bravo.example.com');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{ip_addr}
    ne '192.168.1.17');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{mac_addr}
    ne '00:1E:4F:33:35:D4');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[3] ne 'new_services');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[3] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[4]->[0]->{portid} ne '8');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[4]->[0]->{proto} ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[4]->[0]->{status}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[7] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[8]->[0]->{portid} ne '12');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[8]->[0]->{proto} ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[8]->[0]->{status}
    ne 'open|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[11] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[12]->[0]->{portid} ne '8');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[12]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[12]->[0]->{status}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[15] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[16]->[0]->{portid}
    ne '12');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[16]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[16]->[0]->{status}
    ne 'open|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[7] ne 'missing_services');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[11] ne 'changed_services');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[3] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{portid} ne '6');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{status}
    ne 'open|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[7] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{portid}
    ne '14');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{previous}
    ne 'unfiltered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{status}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[11] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{portid}
    ne '6');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{status}
    ne 'open|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[15] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{portid}
    ne '14');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{previous}
    ne 'unfiltered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{status}
    ne 'open');
ok($syntax_check == 0, "Syntax Test ($stage)");

$stage = 'QA Test 14';
$syntax_check = 0;
$command_line = "$^X $script --baseline $baseline --observed $observed"
    . " --format xml --output-hosts c --output-ports f --hk";
$command_output = `$command_line`;
$syntax_check = 1 if (!$command_output);
$parser = new XML::Parser(Style => 'Tree');

eval {
	$tree = $parser->parse($command_output);
};

$syntax_check = 1 if ($@);
$syntax_check = 1 if ($tree->[1]->[7] ne 'changed');
$syntax_check = 1 if ($tree->[1]->[8]->[3] ne 'host');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{hostname}
    ne 'bravo.example.com');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{ip_addr}
    ne '192.168.1.17');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{mac_addr}
    ne '00:1E:4F:33:35:D4');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[3] ne 'new_services');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[3] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[4]->[0]->{portid} ne '10');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[4]->[0]->{proto} ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[4]->[0]->{status}
    ne 'filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[7] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[8]->[0]->{portid} ne '12');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[8]->[0]->{proto} ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[8]->[0]->{status}
    ne 'open|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[11] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[12]->[0]->{portid}
    ne '13');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[12]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[12]->[0]->{status}
    ne 'closed|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[15] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[16]->[0]->{portid}
    ne '10');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[16]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[16]->[0]->{status}
    ne 'filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[19] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[20]->[0]->{portid}
    ne '12');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[20]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[20]->[0]->{status}
    ne 'open|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[23] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[24]->[0]->{portid}
    ne '13');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[24]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[24]->[0]->{status}
    ne 'closed|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[7] ne 'missing_services');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[11] ne 'changed_services');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[3] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{portid} ne '4');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{status}
    ne 'filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[7] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{portid} ne '6');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{status}
    ne 'open|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[11] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{portid}
    ne '7');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{status}
    ne 'closed|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[15] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{portid}
    ne '4');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{status}
    ne 'filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[19] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[20]->[0]->{portid}
    ne '6');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[20]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[20]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[20]->[0]->{status}
    ne 'open|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[23] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[24]->[0]->{portid}
    ne '7');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[24]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[24]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[24]->[0]->{status}
    ne 'closed|filtered');
ok($syntax_check == 0, "Syntax Test ($stage)");

$stage = 'QA Test 15';
$syntax_check = 0;
$command_line = "$^X $script --baseline $baseline --observed $observed"
    . " --format xml --output-hosts c --output-ports c --hk";
$command_output = `$command_line`;
$syntax_check = 1 if (!$command_output);
$parser = new XML::Parser(Style => 'Tree');

eval {
	$tree = $parser->parse($command_output);
};

$syntax_check = 1 if ($@);
$syntax_check = 1 if ($tree->[1]->[7] ne 'changed');
$syntax_check = 1 if ($tree->[1]->[8]->[3] ne 'host');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{hostname}
    ne 'bravo.example.com');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{ip_addr}
    ne '192.168.1.17');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{mac_addr}
    ne '00:1E:4F:33:35:D4');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[3] ne 'new_services');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[7] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[8]->[0]->{portid} ne '13');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[8]->[0]->{proto} ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[8]->[0]->{status}
    ne 'closed|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[11] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[12]->[0]->{portid} ne '9');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[12]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[12]->[0]->{status}
    ne 'closed');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[15] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[16]->[0]->{portid}
    ne '13');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[16]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[16]->[0]->{status}
    ne 'closed|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[7] ne 'missing_services');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[11] ne 'changed_services');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[3] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{portid} ne '3');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{status}
    ne 'closed');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[7] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{portid} ne '7');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{status}
    ne 'closed|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[11] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{portid}
    ne '3');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{status}
    ne 'closed');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[15] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{portid}
    ne '7');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{status}
    ne 'closed|filtered');

ok($syntax_check == 0, "Syntax Test ($stage)");

$stage = 'QA Test 16';
$syntax_check = 0;
$command_line = "$^X $script --baseline $baseline --observed $observed"
    . " --format xml --output-hosts c --output-ports c --hk";
$command_output = `$command_line`;
$syntax_check = 1 if (!$command_output);
$parser = new XML::Parser(Style => 'Tree');

eval {
	$tree = $parser->parse($command_output);
};

$syntax_check = 1 if ($@);
$syntax_check = 1 if ($tree->[1]->[7] ne 'changed');
$syntax_check = 1 if ($tree->[1]->[8]->[3] ne 'host');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{hostname}
    ne 'bravo.example.com');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{ip_addr}
    ne '192.168.1.17');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{mac_addr}
    ne '00:1E:4F:33:35:D4');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[0]->{status} ne 'up');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[3] ne 'new_services');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[3] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[4]->[0]->{portid} ne '9');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[4]->[0]->{proto} ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[4]->[0]->{status}
    ne 'closed');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[7] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[8]->[0]->{portid} ne '13');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[8]->[0]->{proto} ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[8]->[0]->{status}
    ne 'closed|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[11] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[12]->[0]->{portid} ne '9');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[12]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[12]->[0]->{status}
    ne 'closed');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[15] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[16]->[0]->{portid}
    ne '13');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[16]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[4]->[16]->[0]->{status}
    ne 'closed|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[7] ne 'missing_services');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[11] ne 'changed_services');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[3] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{portid} ne '3');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[4]->[0]->{status}
    ne 'closed');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[7] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{portid} ne '7');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{proto}
    ne 'tcp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[8]->[0]->{status}
    ne 'closed|filtered');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[11] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{portid}
    ne '3');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[12]->[0]->{status}
    ne 'closed');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[15] ne 'service');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{portid}
    ne '7');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{previous}
    ne 'open');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{proto}
    ne 'udp');
$syntax_check = 1 if ($tree->[1]->[8]->[4]->[12]->[16]->[0]->{status}
    ne 'closed|filtered');
ok($syntax_check == 0, "Syntax Test ($stage)");

$stage = 'QA Test 17';
$syntax_check = 0;
$baseline = File::Spec->catpath("", 't', 'oA9.xml');
$observed = File::Spec->catpath("", 't', 'issue7.xml');
$command_line = "$^X $script --baseline $baseline --observed $observed"
    . " --format xml";
$command_output = `$command_line`;
$syntax_check = 1 if (!$command_output);
$parser = new XML::Parser(Style => 'Tree');

eval {
	$tree = $parser->parse($command_output);
};

$syntax_check = 1 if ($@);
$syntax_check = 1 if ($tree->[1]->[16]->[3] ne 'host');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[0]->{ip_addr}
    ne '192.168.0.9');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[0]->{mac_addr}
    ne '00:03:47:6D:28:D7');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[0]->{status} ne 'up');
ok($syntax_check == 0, "Syntax Test ($stage)");

# This test is not in the Functional Test Template but ensures that the script
# recognises when it can't use the hostname-key flag
$syntax_check = 0;
$baseline = File::Spec->catpath("", 't', 'dns1.xml');
$observed = File::Spec->catpath("", 't', 'dns2.xml');
$command_line = "$^X $script --baseline $baseline --observed $observed"
    . " --format xml --hk";
my $tmpfile = 'testexec.tmp';
open TMPFILE, ">$tmpfile" or die $!;
STDERR->fdopen(\*TMPFILE, 'w') or die $!;
$command_output = `$command_line`;
unlink($tmpfile);
$syntax_check = 1 if (!$command_output);
$parser = new XML::Parser(Style => 'Tree');

eval {
	$tree = $parser->parse($command_output);
};

$syntax_check = 1 if ($@);
$syntax_check = 1 if ($tree->[1]->[4]->[0]->{node_key} ne 'IP');
$stage =  "Recognises impossible --hostname-key input"
    . " message";
ok($syntax_check == 0, $stage);

# Test that different OS versions are detected.
$syntax_check = 0;
$baseline = File::Spec->catpath("", 't', 'issue25b.xml');
$observed = File::Spec->catpath("", 't', 'issue25o.xml');
$command_line = "$^X $script --baseline $baseline --observed $observed"
    . " --format xml";
$command_output = `$command_line`;
$syntax_check = 1 if (!$command_output);
$parser = new XML::Parser(Style => 'Tree');

eval {
	$tree = $parser->parse($command_output);
};

# Only use the function below when generating test cases.
#displaylist($tree);
$stage = 'OS Detection';
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[16]->[0]->{baseline}
    ne 'FreeBSD 5.2 - 5.3 (100%)');
$syntax_check = 1 if ($tree->[1]->[16]->[4]->[16]->[0]->{observed}
    ne 'FreeNAS 0.686 (FreeBSD 6.2-RELEASE) (100%)');
ok($syntax_check == 0, $stage);

# Nmap version mismatch detection.
$stage = 'Nmap version mismatch detection';
$syntax_check = 1 if ($tree->[1]->[4]->[0]->{nmap_version_warning}
    ne 'true');
ok($syntax_check == 0, $stage);

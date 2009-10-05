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
use Test::Simple tests => 7;
use XML::Parser;
use strict;
 
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

# Now start testing the XML generated.
my $baseline = File::Spec->catpath("", 't', 'baseline_qa.xml');
my $observed = File::Spec->catpath("", 't', 'observed_qa.xml');
$command_line = "$^X $script --baseline $baseline --observed $observed --format xml";
$command_output = `$command_line`;
my $syntax_check = 0;
my $stage = 'generic';
my $tree;
$syntax_check = 1 if (!$command_output);
my $parser = new XML::Parser(Style => 'Tree');

eval {
	$tree = $parser->parse($command_output);
};

$syntax_check = 1 if ($@);
ok($syntax_check == 0, "Produces valid XML ($stage)");
$syntax_check = 1 if ($tree->[0] ne 'yandiff');
$syntax_check = 1 if ($tree->[1]->[3] ne 'parameters');
$syntax_check = 1 if ($tree->[1]->[4]->[0]->{node_key} ne 'IP');
$syntax_check = 1 if ($tree->[1]->[4]->[3] ne 'baseline');
$syntax_check = 1 if ($tree->[1]->[4]->[4]->[3] ne 'file');
print Dumper($tree->[1]->[4]->[4]->[4]->[2]);
ok($syntax_check == 0, "Syntax Test ($stage)");

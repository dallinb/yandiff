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
use strict;
 
#############################################################################
# Below are a couple of utility functions for generating test cases.  If one
# were to try to do this manually then a switch from the IT sector in search
# of a better life would surely follow.
#############################################################################
sub displaylist {
	my ($current, @tree) = @_;
	my $inset = "\$tree->";
	my $key;

	for my $i (@tree) {
		$inset .= "\[$i\]\->";
	}

	for ($key = 0; $key < @$current; $key++) {
		if (my $type = ref $$current[$key]) {
			if ($type eq "ARRAY") {
				push @tree, $key;
				displaylist($$current[$key], @tree);
				pop @tree;
			} elsif ($type eq "HASH") {
				displayhash($inset,$$current[$key]);
			}
		} else {
			my $info = $$current[$key];
			print_line ("\$syntax_check = 1 "
			    . "if ($inset\[$key] ne \'$info\');\n");
		}
	}
}

sub displayhash {
	my ($inset,$current) = @_;
	my $key;

	foreach $key (sort keys %$current) {
		if (my $type = ref $$current{$key}) {
			if ($type eq "ARRAY") {
				displaylist($inset,$$current{$key});
			} elsif ($type eq "HASH") {
				displayhash($inset,$$current{$key});
			}
		} else {
			my $info = $$current{$key};
			print_line ("\$syntax_check = 1"
			    . " if ($inset\[0\]\->\{$key\} ne \'$info\');\n");
		}
	}
}

sub print_line {
	my $line = shift;

	if (length($line) <= 78) {
		print $line if (length($line) <= 78);
		return;
	}

	my @lines = split ' ne ', $line;
	printf("%s\n    ne %s", $lines[0], $lines[1]);
}

1;

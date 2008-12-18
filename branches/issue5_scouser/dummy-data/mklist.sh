#!/bin/bash
#
##############################################################################
#
# Copyright (c) 2008, League of Crafty Programmers Ltd <info@locp.co.uk>
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# * Redistributions of source code must retain the above copyright
#   notice, this list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY LEAGUE OF CRAFTY PROGRAMMERS ''AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL LEAGUE OF CRAFTY PROGRAMMERS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
##############################################################################
#

# Generate a MAC address in the format of  00:1E:4F:XX:XX:XX
function generate_mac_address {
	md5=$( echo $RANDOM | md5sum | cut -c1-6 | tr 'a-z' 'A-Z' )
	echo $md5 | awk '{
		printf("00:1E:4F:%s:%s:%s\n",
			substr($0, 0, 2),
			substr($0, 2, 2),
			substr($0, 4, 2));
	}'
}

octet3=0
octet4=254
node=1

while (( node <= 1024 )); do
	if (( node <= 16 )); then
		printf -v hostname "s%03d.example.com" $node
		template=server.xml
	else
		(( w = node - 16 ))
		printf -v hostname "w%03d.example.com" $w
		template=workstation.xml
	fi

	if (( octet4 >= 254 )); then
		octet4=1
		(( octet3 += 1 ))
	else
		(( octet4 += 1 ))
	fi

	ip=192.168.${octet3}.${octet4}
	echo $hostname,$ip,$template,$( generate_mac_address )
	(( node += 1 ))
done

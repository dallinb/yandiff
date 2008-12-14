#!/bin/bash
#
# A script that generates an XML file that resembles the output from Nmap.
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

# Generate a number of servers
generate_hosts () {
	max=$2
	number=1

	while (( $number <= $max )); do
		if [ $1 = "server" ]; then
			printf -v hostname "s%03d" $number
			generate_server $hostname "ip" $(generate_mac_address)
		else
			printf -v hostname "w%03d" $number
		fi

		(( number += 1 ))
	done
}

# Generate a host XML node
generate_server () {
	hostname=$1
	ip=$2
	mac=$3
	echo "Hostname: $1 IP: $2 MAC: $3"
}

# Generate a fake Intel MAC address
generate_mac_address () {
	echo $RANDOM > $TMPFILE
	mac=`md5sum $TMPFILE`
	echo $mac | tr 'a-z' 'A-Z' | awk '
	{
	    printf("00:03:47:%s:%s:%s\n", substr($0, 0, 2), substr($0, 2, 2),
	        substr($0, 4, 2));
	}'
	#"00:03:47:6D:28:D7"
}

# Declare global variables
TMPFILE=/tmp/$$tmp

generate_hosts server 25

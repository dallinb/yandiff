## NAME ##
> yandiff - Yet Another Nmap Differential Script

## SYNOPSIS ##
> yandiff `[`-f, --format <text | xml>`]` `[`-hk, --hostname-key`]` `[`-of, --output-file file`]` `[`-oh, --output-hosts `<`nmc`>]` `[`-op, --output-ports `<`ofcx`>]` `[`-s, --stylesheet <file | URL>`]` --baseline file --observed file

> yandiff file file

> yandiff --help | -?

> yandiff --man

> yandiff --version

## OPTIONS ##
> -b file

> --baseline file
> > Specifies the nmap results to use as the baseline for the comparison.  May be ommitted if the baseline and observed files
> > are the only two arguments given.


> -f <text | xml>

> --format <text | xml>
> > Specifies the output format (text is the default).


> -h

> --help
> > Print a brief help message and exit.


> -hk

> --hostname-key
> > This flag can be used in a DHCP environment where host names remain static but
> > IP addresses are allocated dynamically.  As an example, a baseline is carried
> > out on a windows PC (win1) which has an IP of 192.168.1.8 and a Linux node
> > (linux1) with an IP of 192.168.1.16.  By the time an observed scan is carried
> > out, both nodes have been rebooted and reallocated each other's address while
> > retaining their configured names.  Using this flag, the IP addresses are mapped
> > back to the original hosts so that win1 in the baseline is compared to win1 in
> > the observed file.  Otherwise the IP addresses would be used for the comparison
> > meaning win1 would be incorrectly compared to linux1 and vice versa.  Using
> > this flag in an environment with static IP allocation would have no functional
> > effect.  There would simply be the performance overhead of the unnecessary
> > mapping logic.


> -m

> --man
> > Print the manual page and exit.


> -o file

> --observed file
> > Specifies the nmap results to use as the "observed results" for the comparison.  May be ommitted if the baseline and
> > observed files are the only two arguments given.


> -of file

> --output-file file
> > Send the output to the specified file.


> -oh `<`nmc`>`

> --output-hosts `<`nmc`>`
> > Specifies which types of hosts to display.  Any combination of n, m, or c may be specified, as follows:


> n = new hosts in the "observed" scan.

> m = missing hosts in the "observed" scan.

> c = changed hosts in the "observed" scan.

> The default is to show new, missing and changed hosts.

> -op `<`ofcx`>`

> --output-ports `<`ofcx`>`
> > Specifies which ports to check when outputting changed hosts. Open, filtered or closed ports.  Any combination of `[`ofcx`]` may
> > be specified, as follows:


> o = open ports in the "observed" scan.

> f = filtered ports in the "observed" scan.

> c = closed ports in the "observed" scan.

> x = unfiltered ports in the "observed" scan

> The default is to show all ports.

> -s <file | URL>

> --stylesheet <file | URL>
> > Specifies the location of an XML stylesheet to be referred to in any XML output.


> -V

> --version
> > Print the version and exit.



## DESCRIPTION ##
'''yandiff''' is a command line utility (written in Perl) that allows users to monitor networks for changes in port states and running services. It does this by comparing the XML output of two nmap scans, one designated the "baseline", the other the "observation". Alternatively a third XML file can be created containing the differences.

## EXAMPLES ##
To generate a report to screen:


> yandiff baseline.xml observed.xml

which is equivalent to

> yandiff --baseline baseline.xml --observed observed.xml

To generate a report to an XML file and using a stylesheet:

> yandiff --baseline baseline.xml --observed observed.xml                    --format xml --output-file report.xml --stylesheet yandiff.xsl


## HISTORY ##
Yandiff is loosely based on ndiff written by James Levine, except where ndiff used "grepable" output from nmap, yandiff reads XML output using Nmap::Parser.

## AUTHORS ##
The Yandiff project at http://code.google.com/p/yandiff

## BUGS ##
The project members graciously accept that there may be bugs. If there are any found, please report them at the link below or browse the issues reported to see if a fix is either available or in progress.

http://code.google.com/p/yandiff/issues

Also it could be said that there are too many command line switches.  Even
the authors require the occassional reference to the manual.  We're sorry, we
have tried to keep it simple.
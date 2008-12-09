xndiff allows a network administrator or other interested party to easily
monitor one or more networks for changes in port states and running
services.  It achieves this by comparing the results of two nmap scans,
one designated the "baseline", the other "observation".

Both baseline and observation are stored in files generated via nmap’s -oX
switch for XML output.

Xndiff is loosely based on ndiff written by James Levine, except where ndiff
used nmap’s "grepable" output, xndiff reads XML output using Nmap::Parser.

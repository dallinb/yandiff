Description
===========

xndiff allows a network administrator or other interested party to easily
monitor one or more networks for changes in port states and running
services.  It achieves this by comparing the results of two nmap scans,
one designated the "baseline", the other "observation".

Both baseline and observation are stored in files generated via nmap’s -oX
switch for XML output.

Xndiff is loosely based on ndiff written by James Levine, except where ndiff
used nmap’s "grepable" output, xndiff reads XML output using Nmap::Parser.

Building a Distribution
=======================

This section is only useful if you intend to create a distribution.  It
also assumes you're using Subversion.

In a release branch, ensure that the manifest is up to date, if necessary
run:

	perl Build.PL
	perl Build manifest

Ensure that the $VERSION string is set correctly in bin/xndiff (in this example
it is version 0.4) and make sure that CHANGES.txt has been updated.  Then
run the following:
 
	perl Build.PL 
	perl disttest
	perl Build disttest
	perl Build dist
	tar xzvf xndiff-0.4.tar.gz 
	zip -Dlvr xndiff-0.4.zip xndiff-0.4
	perl Build realclean
	svn status

If all has gone well, you should have a zip archive and a gzipped tarball.

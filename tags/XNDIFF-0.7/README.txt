Description
===========

Xndiff is a command line utility (written in Perl) that allows users to monitor
networks for changes in port states and running services. It does this by
comparing the XML output of two nmap scans, one designated the "baseline", the
other the "observation". Alternatively a third XML file can be created
containing the differences.

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
it is version 0.7) and make sure that CHANGES.txt has been updated.  Then
run the following:
 
	perl Build.PL 
	perl Build disttest
	perl Build dist
	tar xzvf xndiff-0.7.tar.gz 
	zip -Dlvr xndiff-0.7.zip xndiff-0.7
	perl Build realclean
	svn status

If all has gone well, you should have a zip archive and a gzipped tarball.

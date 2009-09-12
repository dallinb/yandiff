Description
===========

Yandiff (previously called Xndiff) is a command line utility (written in Perl)
that allows users to monitor networks for changes in port states and running
services. It does this by comparing the XML output of two nmap scans, one
designated the "baseline", the other the "observation". Alternatively a third
XML file can be created containing the differences.

It is loosely based on ndiff written by James Levine (circa 2001), except where
ndiff used nmap’s "grepable" output, yandiff reads XML output using
Nmap::Parser.

Building a Distribution
=======================

This section is only useful if you intend to create a distribution.  It
also assumes you're using Subversion.

In a release branch, ensure that the manifest is up to date, if necessary
run:

	perl Build.PL
	perl Build manifest

Ensure that the $VERSION string is set correctly in bin/yandiff (in this
example it is version 1.2) and make sure that CHANGES.txt has been updated.
Then run the following:
 
	perl Build.PL 
	perl Build disttest
	perl Build dist
	tar xzvf yandiff-1.2.tar.gz 
	zip -Dlvr yandiff-1.2.zip yandiff-1.2
	perl Build realclean
	svn status

If all has gone well, you should have a zip archive and a gzipped tarball.

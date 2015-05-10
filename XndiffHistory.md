# The Release History of Xndiff #

17 June 2009 - **Release 0.7**.  Allows the user to use a slightly less verbose
command line for a quick check.  Also the output of both text and
XML reports now show what the previous status of a port was.

24 January 2009 - **Release 0.6**.  Sorted out how the command line worked by
allowing shorted options for the user, tightened up the logic when
the --version or --gen-stylesheet options were used and a
stylesheet is automatically generated if it doesn't exist when using the
--stylesheet option.

07 January 2009 - **Release 0.5**.  This release fixed a bug which
had unfiltered ports being shown when only filtered ports were
requested.

28 December 2008 - **Release 0.4**.  This release fixed the following bugs:

  * Script hangs on Windows.

It also added the following enhancement:

  * The script now allows the user to filter which changed ports should be shown.

10 December 2008 - **Release 0.3**.  This release implemented a different install method to move towards a less Linux/Unix dependant release.  Also this script generates a different (and hopefully improved) XML stylesheet.

29 November 2008 - **Release 0.2**.  This release removed references from the old ISC license and changed contact details to the Google Code project page.

25 November 2008 - **Release 0.1**.  The initial release after migrating from a local Subversion repository and from an ISC license to the New BSD to be compatible with Google Code policy.
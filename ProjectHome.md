Yandiff ([previously called Xndiff](history.md)) is a command line utility (written in Perl) that allows users to monitor networks for changes in port states and running services. It does this by comparing the XML output of two nmap scans, one designated the "baseline", the other the "observation". Alternatively a third XML file can be created containing the differences.

It is loosely based on ndiff written by James Levine (_circa_ 2001), except where ndiff used nmap’s "grepable" output, yandiff reads XML output using
[Nmap::Parser](http://code.google.com/p/nmap-parser).

---

## Latest Release ##
4 January 2010 - **Release 1.3**.  Two changes ([issue5](https://code.google.com/p/yandiff/issues/detail?id=5) & [issue23](https://code.google.com/p/yandiff/issues/detail?id=23)) simply changed
the format of the code but was for the sake of the developers and did not add,
change or remove any functionality.  Testing has been made a bit stricter at
install time when the user runs "Build test" with a much larger number of tests
now being carried out ([issue10](https://code.google.com/p/yandiff/issues/detail?id=10)).  A defect that meant that spurious null
hostnames would be shown under some circumstances has been fixed ([issue27](https://code.google.com/p/yandiff/issues/detail?id=27)).
Finally, a user is notified if a changed node has had it's operating system
changed ([issue25](https://code.google.com/p/yandiff/issues/detail?id=25)).  There is also a warning if the version of Nmap has changed
between the baseline and observed scans ([issue28](https://code.google.com/p/yandiff/issues/detail?id=28)).


---

## Previous Releases ##
12 September 2009 - **Release 1.2**.  This release fixes a minor issue introduced
in release 1.1 where a diagnostic warning was show when a host didn't have a
MAC address ([issue15](https://code.google.com/p/yandiff/issues/detail?id=15)).  Also tidied up the documentation and source code logic
for the --hostname-key ([issue18](https://code.google.com/p/yandiff/issues/detail?id=18)).  Due to an oversight `<blame>`Ben
Dalling`</blame>`, the MAC address wasn't shown in the stylesheet, even though
they were appearing in the XML output file ([issue16](https://code.google.com/p/yandiff/issues/detail?id=16)).

20 August 2009 - **Release 1.1**.  This release fixes a minor bug ([issue7](https://code.google.com/p/yandiff/issues/detail?id=7)) that incorrectly shows a hostname as '0' when there was not a hostname in the original Nmap report.  The following changes and enhancements have been made:

  * The --hostname-key option has been added to assist in analysing hosts that are in a DHCP environment where hostnames remain static but the IP address is randomly allocated ([issue3](https://code.google.com/p/yandiff/issues/detail?id=3)).
  * The MAC address of any new, missing or changed host is now shown in the Yandiff reports ([issue4](https://code.google.com/p/yandiff/issues/detail?id=4)).
  * The stylesheet has been updated to reflect this bug fix and the included enhancements ([issue8](https://code.google.com/p/yandiff/issues/detail?id=8)).

17 July 2009 - **Release 1.0**.  Basically a rename of [Xndiff-0.7](http://code.google.com/p/yandiff/wiki/XndiffHistory) to Yandiff-1.0.

Contact email: info _AT_ locp.co.uk

---

## Screenshots ##

Click on the images below to see the bigger picture.

| **Default Text Output** | **XML Output with Stylesheet** |
|:------------------------|:-------------------------------|
|![![](http://sites.google.com/site/yandiff/images/yandiff-figure2-363x322.png)](http://sites.google.com/site/yandiff/images/yandiff-figure2.png)|![![](http://sites.google.com/site/yandiff/images/yandiff-figure3-360x322.png)](http://sites.google.com/site/yandiff/images/yandiff-figure3.png)|
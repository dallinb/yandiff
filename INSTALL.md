Dependencies:

> Software:
> > perl


> Perl Modules:
> > Getopt::Long<br />
> > IO::Handle<br />
> > Module::Build	(for installation only)<br />
> > Nmap::Parser<br />
> > Pod::Usage

To install this software into the default location (/usr/local or /usr in
Linux) do the following after decompressing the archive and going to the
directory where it was extracted to:


> perl Build.PL<br />
> perl Build build<br />
> perl Build install

To install in an alternative location specify a prefix for where the software
is to be installed.  For example, this set of commands will install the
software in a directory called $HOME/yandiff:

> perl Build.PL --install\_base $HOME/yandiff<br />
> perl Build build<br />
> perl Build install

If you had specified the alternative prefix (as above) then the following
files would be installed:

> $HOME/yandiff/man/man1/yandiff.1p<br />
> $HOME/yandiff/bin/yandiff
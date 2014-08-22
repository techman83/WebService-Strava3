WebService-Strava3
==================

A Perl client to Version 3 of the Strava.com API

You will need to register for a Client Secret + Access token here:
https://www.strava.com/settings/api

Set the authorization callback domain to: http://127.0.0.1

To setup your authentication run the following
```bash
strava setup
```

It will generate a file `~/.stravarc` where the authentication information is stored.

It will be available on CPAN soon, but you can install after cloning from github and
using cpanminus.

Grab cpanm + local::lib
```bash
$ sudo apt-get install cpanminus liblocal-lib-perl
```

Configure local::lib if you haven't already done so:

```bash
$ perl -Mlocal::lib >> ~/.bashrc
$ eval $(perl -Mlocal::lib)
```

Install from git, you can then use:

```bash
$ dzil authordeps | cpanm
$ dzil listdeps   | cpanm
$ dzil install
```

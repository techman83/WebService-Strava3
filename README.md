WebService-Strava3
==================

A Perl client to Version 3 of the Strava.com API

You will need to register for a Client Secret + Access token here:
https://www.strava.com/settings/api

Set the authorization callback domain to: urn:ietf:wg:oauth:2.0:oob

To setup your authentication run the following
```bash
strava setup
```

It will generate a file `~/.stravarc` where the authentication information is stored.

#!/usr/env/perl

use strict;
use WebService::Strava::Auth;

$ENV{STRAVA_DEGUG} = 1;

my $strava = WebService::Strava::Auth->new();

#$strava->segment("3468536");

$strava->auth;

print Dumper($strava);


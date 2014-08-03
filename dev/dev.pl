#!/usr/env/perl

use strict;
use WebService::Strava;

$ENV{STRAVA_DEGUG} = 1;

my $strava = WebService::Strava->new();

$strava->auth->setup;


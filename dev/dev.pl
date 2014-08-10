#!/usr/env/perl

use strict;
use feature qw(say);
use WebService::Strava;
use Data::Dumper;

$ENV{STRAVA_DEGUG} = 1;

my $strava = WebService::Strava->new();

#my $athlete = $strava->athlete();

#my $segment = $strava->auth->get("https://www.strava.com/api/v3/segments/3468536");

#say "$strava->{auth}{expires_in}"

#print Dumper($strava);

#print Dumper($segment);
#my $efforts = $segment->list_efforts(athlete_id => 226646);

#@{$athlete->{clubs}}[0]->retrieve();

#my $effort = $strava->effort("4101511026");

my $activity = $strava->activity("5357306");

print Dumper($activity);

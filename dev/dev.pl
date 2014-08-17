#!/usr/env/perl

use strict;
use feature qw(say);
use WebService::Strava;
use Data::Dumper;

$ENV{STRAVA_DEBUG} = 1;

my $strava = WebService::Strava->new();

#my $athlete = $strava->athlete();

#my $segment = $strava->auth->get("https://www.strava.com/api/v3/segments/3468536");

#say "$strava->{auth}{expires_in}"

#print Dumper($strava);

#print Dumper($segment);
#my $efforts = $segment->list_efforts(athlete_id => 226646);

#@{$athlete->{clubs}}[0]->retrieve();

#my $effort = $strava->effort("4101511026");

#my $activity = $strava->activity("5357306");

#my $records = $strava->athlete->list_records();
#@{$records}[0]->retrieve;
#@{$records}[0]->segment->retrieve;

#my $activities = $strava->list_friends_activities();
#@{$activities}[0]->retrieve();

#my $clubs = $strava->clubs(1);
my $club = @{$strava->clubs()}[0];
#my $members = $club->list_members();
my $activities = $club->list_activities();

print Dumper($activities);

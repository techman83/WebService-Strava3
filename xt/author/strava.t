#!/usr/bin/perl -w

use strict;
use Test::More;
use WebService::Strava;
use Data::Dumper;

my $strava = WebService::Strava->new();

pass("Strava Testing");
subtest 'Base Strava Object Tests' => sub {
  isa_ok($strava, 'WebService::Strava');
  isa_ok($strava->auth, 'WebService::Strava::Auth');
  can_ok($strava, qw(auth athlete clubs segment list_starred_segments
      effort activity list_activities list_friends_activities));  
  can_ok($strava->auth, qw(get post auth get_api setup));
  done_testing();
};

my $athlete = $strava->athlete;
subtest 'Athlete Tests' => sub {
  isa_ok($athlete, 'WebService::Strava::Athlete');
  can_ok($athlete, qw(list_records));
  ok($athlete->firstname eq 'Leon', 'User correctly returned');
  done_testing();
};

#print Dumper($athlete);
done_testing();


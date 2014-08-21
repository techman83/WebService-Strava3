#!/usr/bin/perl -w

use strict;
use Test::More;
use WebService::Strava;
use Data::Dumper;

my $strava = WebService::Strava->new();

pass("Strava Testing");
subtest 'Strava' => sub {
  isa_ok($strava, 'WebService::Strava');
  isa_ok($strava->auth, 'WebService::Strava::Auth');
  can_ok($strava, qw(auth athlete clubs segment list_starred_segments
      effort activity list_activities list_friends_activities));  
  can_ok($strava->auth, qw(get post auth get_api setup));
  
  subtest 'Strava Methods' => sub {
    my $clubs = $strava->clubs;
    if (@{$clubs}[0])  {
      is( ref( $clubs ), 'ARRAY', 'Clubs is an array' );
      isa_ok( @{$clubs}[0], 'WebService::Strava::Club');
    } else {
      note('Current authenticated user is not associated with a club');
    }

    my $starred = $strava->list_starred_segments;
    if (@{$starred}[0])  {
      is( ref( $starred ), 'ARRAY', 'Starred is an array' );
      isa_ok( @{$starred}[0], 'WebService::Strava::Segment');
    } else {
      note('Current authenticated user has not starred a segment');
    }

    my $activities = $strava->list_activities;
    if (@{$activities}[0])  {
      is( ref( $activities ), 'ARRAY', 'Activities is an array' );
      isa_ok( @{$activities}[0], 'WebService::Strava::Athlete::Activity');
    } else {
      note('Current authenticated user has not got any activities');
    }

    my $friends_activities = $strava->list_friends_activities;
    if (@{$friends_activities}[0])  {
      is( ref( $friends_activities ), 'ARRAY', 'Friends activities is an array' );
      isa_ok( @{$friends_activities}[0], 'WebService::Strava::Athlete::Activity');
    } else {
      note('Current authenticated user has not got any friends with activities');
    }
  };
};

my $athlete = $strava->athlete;
subtest 'Athlete' => sub {
  isa_ok($athlete, 'WebService::Strava::Athlete');
  can_ok($athlete, qw(list_records));
  isnt($athlete->{firstname}, undef, 'User returned');

  if (@{$athlete->{clubs}}[0])  {
    subtest 'Athlete Clubs' => sub {
      is( ref( $athlete->{clubs} ), 'ARRAY', 'Clubs is an array' );
      isa_ok( @{$athlete->{clubs}}[0], 'WebService::Strava::Club');
      my $club_activities = @{$athlete->{clubs}}[0]->list_activities();
      if (@{$club_activities}[0]) {
        is( ref( $club_activities ), 'ARRAY', 'Club Activities is an array' );
        isa_ok( @{$club_activities}[0], 'WebService::Strava::Athlete::Activity');
        can_ok(@{$club_activities}[0], qw(retrieve));
      } else {
        note('Current club appears to have no activities');
      }
    };
  } else {
    note('Current authenticated user is not associated with a club');
  }

  if (@{$athlete->{bikes}}[0])  {
    subtest 'Athlete Bikes' => sub {
      is( ref( $athlete->{bikes} ), 'ARRAY', 'Bikes is an array' );
      isa_ok( @{$athlete->{bikes}}[0], 'WebService::Strava::Athlete::Gear::Bike');
    };
  } else {
    note('Current authenticated user doesn\'t have any bikes');
  }

  if (@{$athlete->{shoes}}[0])  {
    subtest 'Athlete Bikes' => sub {
      is( ref( $athlete->{shoes} ), 'ARRAY', 'Shoes is an array' );
      isa_ok( @{$athlete->{shoes}}[0], 'WebService::Strava::Athlete::Gear::Shoe');
    };
  } else {
    note('Current authenticated user doesn\'t have any shoes');
  }
};

my $segment = $strava->segment(3468536);
subtest 'Segment' => sub {
  isa_ok($segment, 'WebService::Strava::Segment');
  can_ok($segment, qw(retrieve list_efforts leaderboard));
  is($segment->{activity_type}, 'Ride', 'activity_type is a Ride');
  
  subtest 'Segment: List Efforts' => sub { 
    my $efforts = $segment->list_efforts;
    is( ref( $efforts ), 'ARRAY', 'Efforts is an array' );
    isa_ok( @{$efforts}[0], 'WebService::Strava::Athlete::Segment_Effort');
    can_ok(@{$efforts}[0], qw(retrieve));
  };
  
  subtest 'Segment: Leaderboard' => sub { 
    my $leaderboard = $segment->leaderboard;
    is( ref( $leaderboard ), 'ARRAY', 'Leaderboard is an array' );
  };
};

done_testing();

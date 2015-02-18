#!/usr/bin/perl -w

use lib 't/lib/';
use strict;
use warnings;

use WebService::Strava::Test;
use Test::Most;
use Test::Warnings;

my $tester = WebService::Strava::Test->new();

$tester->test_with_auth(\&user_testing, 3);
$tester->test_with_dancer(\&user_testing, 3);

sub user_testing {
  my ($auth,$message) = @_;

  pass("Auth Testing: $message");  
  use_ok("WebService::Strava::Auth");
  
  subtest 'Instantiation' => sub {
    isa_ok($auth, "WebService::Strava::Auth");
    
    can_ok($auth, qw(setup get post get_api uploads_api));
  };

  subtest 'Get Current User'  => sub {
    my $user = $auth->get_api('/athlete');
    isnt($user->{firstname},  undef, "Athelete Retrieved");
  };

  subtest 'Upload File' => sub {
    # Upload the file
    my $upload = $auth->uploads_api('t/data/sample.gpx','gpx');
    isnt($upload->{id},  undef, "Activity Uploaded");
    is($upload->{external_id}, "sample.gpx", "Filename returned correctly");
    
    # Check it got uploaded
    my $activity;
    my $count = 0;
    while($count < 30) {
      $activity = $auth->get_api("/uploads/$upload->{id}");
      last if $activity->{activity_id};
      $count++;
      sleep 1;
    };
  
    isnt($activity->{activity_id}, undef, "Activity Processed");
    is($activity->{error}, undef, "No errors");
  
    # Delete it
    my $delete = $auth->delete_api("/activities/$activity->{activity_id}"); 
    is($delete, 1, "Activity Deleted");
    $delete = $auth->delete_api("/activities/$activity->{activity_id}"); 
    is($delete, 0, "No activity to delete");
  };
}

done_testing();
__END__

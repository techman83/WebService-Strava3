package WebService::Strava::Test;

use strict;
use warnings;
use WebService::Strava::Auth;
use Moo;
use Method::Signatures;
use Test::Most;

method test_with_auth($test, $number_tests) {
  SKIP: {
    skip "No auth credentials found.", $number_tests unless ( -e "$ENV{HOME}/.stravatest" );

    my $auth = WebService::Strava::Auth->new(
      config_file => "$ENV{HOME}/.stravatest",
    );

    $test->($auth, "Testing Live Strava API");
  }
}

method test_with_dancer($test, $number_tests) {
  SKIP: {
    eval {  
      require Dancer2; 
    };

    skip 'These tests are for cached testing and require Dancer2.', $number_tests if ($@);

    my $pid = fork();

    if (!$pid) {
      exec("t/bin/cached_api.pl");
    }

    # Allow some time for the instance to spawn. TODO: Make this smarter
    sleep 5;

    my $config->{auth} = {
      client_id => '1234',
      client_secret => 'abcdefghijklmnopqrstuv123456',
      token_string => '{
        "create_time" : "1424243324",
        "access_token" : "abcdefghijklmnopqrstuv123456",
        "token_type" : "Bearer",
        "_class" : "LWP::Authen::OAuth2::AccessToken::Bearer"
      }',
    };

    my $auth = WebService::Strava::Auth->new(
      api_base => 'http://localhost:3001',
      config => $config,
    );

    $test->($auth, "Testing Cached API");
  
    # Kill Dancer
    kill 9, $pid;
  }
}

1;

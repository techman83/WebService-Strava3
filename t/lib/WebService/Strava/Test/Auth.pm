package WebService::Strava::Test::Auth;

use Dancer2;
set serializer => 'JSON';

get '/athlete' => sub {
  {
    'resource_state' => 3,
    'clubs' => [],
    'sex' => 'M',
    'email' => 'strava_test@example.com',
    'bikes' => [
                 {
                   'id' => 'b1816631',
                   'distance' => '11097',
                   'name' => 'Giant',
                   'resource_state' => 2,
                   'primary' => 1,
                 }
               ],
    'badge_type_id' => 0,
    'firstname' => 'Perl API',
    'country' => 'Australia',
    'mutual_friend_count' => 0,
    'state' => 'Western Australia',
    'profile' => 'avatar/athlete/large.png',
    'follower' => undef,
    'lastname' => 'Testing',
    'friend' => undef,
    'premium' => 0,
    'shoes' => [
                 {
                   'primary' => 1,
                   'resource_state' => 2,
                   'name' => 'No name Worn Flimsy',
                   'distance' => '0',
                   'id' => 'g683635'
                 }
               ],
    'measurement_preference' => 'meters',
    'id' => 1234567,
    'city' => 'Perth',
    'ftp' => undef,
    'date_preference' => '%m/%d/%Y',
    'friend_count' => 0,
    'updated_at' => '2015-02-18T07:18:04Z',
    'created_at' => '2015-02-18T07:13:24Z',
    'profile_medium' => 'avatar/athlete/medium.png',
    'follower_count' => 0
  };
};

post '/uploads' => sub {
  { 
    id => 12345678,
    external_id => "sample.gpx",
    error => undef,
    status => "Your activity is still being processed.",
    activity_id => undef,
  }
};

get '/uploads/:id' => sub {
  {
    'external_id' => 'sample.gpx',
    'activity_id' => 123456789,
    'id' => 12345678,
    'error' => undef,
    'status' => 'Your activity is ready.'
  };
};

# XXX: Probably a little dodgy, but it works
our $blarg;

del '/activities/:id' => sub {
  if ($blarg) {
    status '404';
  } else {
    $blarg = 1;
    status '204';
  }
};

1;

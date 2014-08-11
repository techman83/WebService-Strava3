package WebService::Strava;
use v5.010;
use strict;
use warnings;
use autodie;
use Moo;
use Method::Signatures;
use Data::Dumper;
use Carp qw(croak);

our $DEBUG = $ENV{STRAVA_DEBUG} || 0;

# ABSTRACT: Access Strava via version 3 of the API

# VERSION: Generated by DZP::OurPkg:Version

=head1 SYNOPSIS

    use WebService::Strava;

    my $strava = WebService::Strava->new );

=head1 DESCRIPTION

  I shall write one...

=cut

use WebService::Strava::Auth;

has 'auth' => (
  is => 'ro',
  isa => sub { "WebService::Strava::Auth" },
  lazy => 1,
  builder => 1,
  handles => [ qw( get post ) ],
);

method _build_auth() {
  return WebService::Strava::Auth->new();
}

=method athlete

  $strava->athlete([$id]);

Takes an optional id and will retrieve a L<WebService::Strava::Athlete> 
with details Athlete retrieved. Currently authenticated user will be
returned unless an ID is provided.

=cut

use WebService::Strava::Athlete;

method athlete($id?) {
  return WebService::Strava::Athlete->new(id =>$id, auth => $self->auth);
}

=method segment

  $strava->segment($id);

Takes an mandatory id and will retrieve a
L<WebService::Strava::Segment> with details about the Segment ID retrieved.

After instantiation it is possible to retrieve efforts listed for that segment. It 
takes 3 optional named parameters of 'athlete_id', 'page' and 'efforts'.

  $segment->list_efforts([athlete_id => 123456], [page => 2], [efforts => 100])'

 * 'athelete_id' will return the segment efforts (if any) for the athelete
    in question.

The results are paginated and a maximum of 200 results can be returned
per page.

=cut

use WebService::Strava::Segment;

method segment($id) {
  return WebService::Strava::Segment->new(id =>$id, auth => $self->auth);
}

=method effort

=cut

use WebService::Strava::Athlete::Segment_Effort;

method effort($id) {
  return WebService::Strava::Athlete::Segment_Effort->new(id =>$id, auth => $self->auth);
}

=method activity

=cut

use WebService::Strava::Athlete::Activity;

method activity($id) {
  return WebService::Strava::Athlete::Activity->new(id =>$id, auth => $self->auth);
}

=method list_activities()

  $athlete->list_activities([page => 2], [activities => 100]), [before => 1407665853], [after => 1407665853] '

Returns an arrayRef activities for the current authenticated user. Takes 4 optional
parameters of 'page', 'activities' (per page), 'before' (activities before unix epoch),
and 'after' (activities after unix epoch).

The results are paginated and a maximum of 200 results can be returned
per page.

=cut

method list_activities(:$activities = 25, :$page = 1, :$before?, :$after?) {
  # TODO: Handle pagination better use #4's solution when found.
  my $url = "/athlete/activities?per_page=$activities&page=$page";
  $url .= "&before=$before" if $before;
  $url .= "&before=$after" if $after;
  my $data = $self->auth->get_api("$url");
  my $index = 0;
  foreach my $activity (@{$data}) {
    @{$data}[$index] = WebService::Strava::Athlete::Activity->new(id => $activity->{id}, auth => $self->auth, _build => 0);
    $index++;
  }
  return $data;
};

=head1 ACKNOWLEDGEMENTS

Fred Moyer <fred@redhotpenguin.com> - Giving me Co-Maint on WebService::Strava

Paul Fenwick <pjf@cpan.org> - For being generally awesome, providing inspiration,
assistance and a lot of boiler plate for this library.

=cut

1;

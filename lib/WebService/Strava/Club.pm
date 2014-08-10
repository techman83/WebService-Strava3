package WebService::Strava::Club;

use v5.010;
use strict;
use warnings;
use Moo;
use Method::Signatures;
use Scalar::Util qw(looks_like_number);
use Carp qw(croak);
use Scalar::Util::Reftype;
use Data::Dumper;

# ABSTRACT: A Strava Club Object

# VERSION: Generated by DZP::OurPkg:Version

=head1 SYNOPSIS

  This will return a Club Gear Object.

=head1 DESCRIPTION
  
  An Athlete can be a member of one or many clubs.

=cut

# Validation functions

my $Ref = sub {
  croak "auth isn't a 'WebService::Strava::Auth' object!" unless reftype( $_[0] )->class eq "WebService::Strava::Auth";
};

my $Bool = sub {
  croak "$_[0] must be 0|1" unless $_[0] =~ /^[01]$/;
};

my $Num = sub {
  croak "$_[0] isn't a valid id" unless looks_like_number $_[0];
};

# Debugging hooks in case things go weird. (Thanks @pjf)

around BUILDARGS => sub {
  my $orig  = shift;
  my $class = shift;
  
  if ($WebService::Strava::DEBUG) {
    warn "Building task with:\n";
    warn Dumper(\@_), "\n";
  }
  
  return $class->$orig(@_);
};

# Authentication Object
has 'auth'            => ( is => 'ro', required => 1, isa => $Ref );

# Defaults + Required
has 'id'                      => ( is => 'ro', required => 1, isa => $Num);
has '_build'                  => ( is => 'ro', default => sub { 1 }, isa => $Bool );

has 'profile'         => ( is => 'ro', lazy => 1, builder => '_build_club' ); 
has 'name'            => ( is => 'ro', lazy => 1, builder => '_build_club' );
has 'state'           => ( is => 'ro', lazy => 1, builder => '_build_club' );
has 'city'            => ( is => 'ro', lazy => 1, builder => '_build_club' );
has 'sport_type'      => ( is => 'ro', lazy => 1, builder => '_build_club' );
has 'description'     => ( is => 'ro', lazy => 1, builder => '_build_club' );
has 'member_count'    => ( is => 'ro', lazy => 1, builder => '_build_club' );
has 'country'         => ( is => 'ro', lazy => 1, builder => '_build_club' );
has 'club_type'       => ( is => 'ro', lazy => 1, builder => '_build_club' );

sub BUILD {
  my $self = shift;

  if ($self->{_build}) {
    $self->_build_club();
  }
  return;
}

method _build_club() {
  my $club = $self->auth->get_api("/clubs/$self->{id}");
 
  foreach my $key (keys %{ $club }) {
    $self->{$key} = $club->{$key};
  }

  return;
}

method retrieve() {
  $self->_build_club();
}

1;

package WebService::Strava::Athlete::Gear;

use v5.010;
use strict;
use warnings;
use Moo;
use Method::Signatures;
use Scalar::Util qw(looks_like_number);
use Carp qw(croak);
use Scalar::Util::Reftype;
use Data::Dumper;

# ABSTRACT: An Athlete Gear Object

# VERSION: Generated by DZP::OurPkg:Version

=head1 SYNOPSIS

  This class shouldn't be directly instantiated.

=head1 DESCRIPTION

  This is a parent class to 'Gear' objects. Currently Strava
  has two different Gear types Shoe and Bike. They entirely
  the same, however a bike can have a frame and model.

=cut

# Validation functions

my $Ref = sub {
  croak "auth isn't a 'WebService::Strava::Auth' object!" unless reftype( $_[0] )->class eq "WebService::Strava::Auth";
};

my $Bool = sub {
  croak "$_[0] must be 0|1" unless $_[0] =~ /^[01]$/;
};

my $Id = sub {
  croak "$_[0] doesn't appear to be a valid gear id" unless $_[0] =~ /^[bg]\d+/;
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
has 'id'                      => ( is => 'ro', required => 1, isa => $Id);
has '_build'                  => ( is => 'ro', default => sub { 1 }, isa => $Bool );

has 'primary'         => ( is => 'ro', lazy => 1, builder => '_build_gear' ); 
has 'name'            => ( is => 'ro', lazy => 1, builder => '_build_gear' );
has 'distance'        => ( is => 'ro', lazy => 1, builder => '_build_gear' );
has 'brand_name'      => ( is => 'ro', lazy => 1, builder => '_build_gear' );
has 'model_name'      => ( is => 'ro', lazy => 1, builder => '_build_gear' );
has 'description'     => ( is => 'ro', lazy => 1, builder => '_build_gear' );
has 'resource_state'  => ( is => 'ro', lazy => 1, builder => '_build_gear' );

sub BUILD {
  my $self = shift;

  if ($self->{_build}) {
    $self->_build_gear();
  }
  return;
}

method _build_gear() {
  my $gear = $self->auth->get_api("/gear/$self->{id}");
 
  foreach my $key (keys %{ $gear }) {
    $self->{$key} = $gear->{$key};
  }

  return;
}

method retrieve() {
  $self->_build_gear();
}

1;

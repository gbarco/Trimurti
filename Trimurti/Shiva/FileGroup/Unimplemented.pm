package Trimurti::Shiva::FileGroup::Unimplemented;

# ============================================================================
# Croaks on unimplemented protocols
# ============================================================================
use strict;
use warnings;
use Carp qw( croak );

# ============================================================================
require Exporter;
use vars qw($VERSION @ISA @EXPORT);

@ISA = qw(Exporter);
@EXPORT = qw(shiva);

# ============================================================================
sub shiva {
	my $stash = ( @_ );
	
	croak('Trimurti::Shiva::FileGroup::Unimplemented unimplemented protocol ' . $stash->{THIS}->{DESTINATION});
}
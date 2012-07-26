package Trimurti::Vishnu::FileGroup;

# ============================================================================
# Handles configuration 
# ============================================================================
use strict;
use warnings;
use Carp qw( croak );

# ============================================================================
use FileGroup::File;

# ============================================================================
require Exporter;
use vars qw($VERSION @ISA @EXPORT);

@ISA = qw(Exporter);
@EXPORT = qw(process);

# ============================================================================
sub process {
	my ( $file_group, $stash ) = @_;
	
	foreach my $file ( @$file_group->{FILES}) {
		Trimurti::Vishnu::FileGroup::File::process( $file, $file_group, $stash );
	}
}

1;
package Trimurti::Vishnu::FileGroup;

# ============================================================================
# Handles configuration 
# ============================================================================
use strict;
use warnings;
use Carp qw( croak );

# ============================================================================
use Trimurti::Vishnu::FileGroup::File;

# ============================================================================
require Exporter;
use vars qw($VERSION @ISA @EXPORT);

@ISA = qw(Exporter);
@EXPORT = qw(process);

# ============================================================================
sub process {
	my ( $file_group, $stash ) = @_;
	
	crock('No file list in file group ' . $file_group->{NAME}) unless defined $file_group->{FILES};
	
	foreach my $file ( @{$file_group->{FILES}}) {
		Trimurti::Vishnu::FileGroup::File::process( $file, $file_group, $stash );
	}
}

1;
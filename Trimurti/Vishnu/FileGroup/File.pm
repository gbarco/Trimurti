package Trimurti::Vishnu::FileGroup::File;

# ============================================================================
# Handles configuration 
# ============================================================================
use strict;
use warnings;
use Carp qw( croak );
use File::Spec;

# ============================================================================
require Exporter;
use vars qw($VERSION @ISA @EXPORT);

@ISA = qw(Exporter);
@EXPORT = qw(process);

# ============================================================================
sub process {
	my ( $file, $file_group, $stash ) = @_;
	
	open ( SOURCE_FILE, $file ) || croak('Failed to open ' . File::Spec->catfile( $stash->{PROJECT}->{BASE}, $file_group->$file ) );
	
	&_check_destination_dir( File::Spec->catfile( $stash->{PROJECT}->{BASE}, $file_group->{DESTINATION} ) );
	
	open ( DEST_FILE, '>') || croak('Failed to open ' . File::Spec->catfile( $stash->{PROJECT}->{BASE}, $file_group->$file ) );
	
	close ( SOURCE_FILE );
	
	close ( DEST_FILE );
}

sub _check_destination_dir {
	my $dir = shift;
	
	#split, and create dirs por destination croak on errors
}

1;
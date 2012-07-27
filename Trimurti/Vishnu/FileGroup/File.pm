package Trimurti::Vishnu::FileGroup::File;

# ============================================================================
# Handles configuration 
# ============================================================================
use strict;
use warnings;
use Carp qw( croak );
use File::Spec;
use File::Path;

# ============================================================================
require Exporter;
use vars qw($VERSION @ISA @EXPORT);

@ISA = qw(Exporter);
@EXPORT = qw(process);

# ============================================================================
sub process {
	my ( $file, $file_group, $stash ) = @_;
	
	crock('No project base in ' . $stash->{PROJECT}->{NAME} ) unless defined $stash->{PROJECT}->{BASE};
	
	my ( $source_file ) = File::Spec->catfile( $stash->{PROJECT}->{BASE}, $file );
	my ( $destination_file ) = File::Spec->catfile( $stash->{PROJECT}->{BASE}, $file_group->{DESTINATION}, $file );
	
	File::Path::make_path( File::Spec->catfile( $stash->{PROJECT}->{BASE}, $file_group->{DESTINATION} ) );
	
	open ( SOURCE_FILE, $source_file ) || croak('Failed to open ' . $source_file );
	open ( DESTINATION_FILE, '>' . $destination_file) || croak('Failed to open ' . $destination_file );

	&rewrite( \*SOURCE_FILE, \*DESTINATION_FILE, $stash );
	
	close ( SOURCE_FILE );
	close ( DESTINATION_FILE );
}

sub rewrite {
	#read each line and load modules to process VISHNU TAGS
	my ( $source_file, $destination_file, $stash ) = @_;
	
	while ( my $source_line = <$source_file> ) {
		if ( $source_line =~ /<!--\s*VISHNU\s*TAG=["'](\S+?)["']\s*-->/ ) {
			
		}
	}
}

1;
package Trimurti::Vishnu::FileGroup::File;

use lib '../../../';
# ============================================================================
# Handles configuration 
# ============================================================================
use strict;
use warnings;
use Carp qw( croak );
use File::Spec;
use File::Path;
use Trimurti::Vishnu::FileGroup::File::HTML;

# ============================================================================
require Exporter;
use vars qw($VERSION @ISA @EXPORT);

@ISA = qw(Exporter);
@EXPORT = qw(process);

# ============================================================================
sub vishnu {
	my ( $stash ) = @_;
	
	crock('No project base in ' . $stash->{PROJECT}->{NAME} ) unless defined $stash->{PROJECT}->{BASE};
	
	my ( $source_file ) = File::Spec->catfile( $stash->{PROJECT}->{BASE}, $stash->{THIS}->{FILE} );
	my ( $destination_file ) = File::Spec->catfile( $stash->{PROJECT}->{BASE}, $stash->{THIS}->{FILE_GROUP}->{DESTINATION}, $stash->{THIS}->{FILE} );
	
	File::Path::make_path( File::Spec->catfile( $stash->{PROJECT}->{BASE}, $stash->{THIS}->{FILE_GROUP}->{DESTINATION} ) );
	
	open ( SOURCE_FILE, $source_file ) || croak('Failed to open ' . $source_file );
	open ( DESTINATION_FILE, '>' . $destination_file) || croak('Failed to open ' . $destination_file );

	$stash->{THIS}->{SOURCE_FILE_FH} = \*SOURCE_FILE;
	$stash->{THIS}->{DESTINATION_FILE_FH} = \*DESTINATION_FILE;	
	if ( $stash->{THIS}->{FILTER} eq 'HTML' ) {
		Trimurti::Vishnu::FileGroup::File::HTML::vishnu( $stash );
	}	
	undef $stash->{THIS}->{SOURCE_FILE_FH};
	undef $stash->{THIS}->{DESTINATION_FILE_FH};
	
	close ( SOURCE_FILE );
	close ( DESTINATION_FILE );
}

1;
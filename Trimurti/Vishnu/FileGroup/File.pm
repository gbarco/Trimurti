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
	
	my ( $source_file ) = $stash->{THIS}->{FILE}->{NAME};
	my ( $destination_file ) = File::Spec->catfile( $stash->{THIS}->{FILE_GROUP}->{DESTINATION}, $stash->{THIS}->{FILE}->{NAME} );
	
	File::Path::make_path( $stash->{THIS}->{FILE_GROUP}->{DESTINATION} );
	
	$stash->{THIS}->{FILE}->{SOURCE_FILE_FH} = IO::File->new( $source_file ) || croak('Failed to open ' . $source_file );
	$stash->{THIS}->{FILE}->{DESTINATION_FILE_FH} = IO::File->new( '>' . $destination_file) || croak('Failed to open ' . $destination_file );
	if ( $stash->{THIS}->{FILTER}->{NAME} eq 'HTML' ) {
		Trimurti::Vishnu::FileGroup::File::HTML::vishnu( $stash );
	}
	$stash->{THIS}->{FILE}->{SOURCE_FILE_FH}->close();
	$stash->{THIS}->{FILE}->{DESTINATION_FILE_FH}->close();
	
	undef $stash->{THIS}->{FILE}->{SOURCE_FILE_FH};
	undef $stash->{THIS}->{FILE}->{DESTINATION_FILE_FH};
	undef $stash->{THIS}->{FILE};
}

1;
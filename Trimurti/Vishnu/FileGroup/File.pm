package Trimurti::Vishnu::FileGroup::File;

# ============================================================================
# Handles configuration 
# ============================================================================
use strict;
use warnings;
use Carp qw( croak );

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
	my ( $destination_file ) = $stash->{THIS}->{FILE}->{NAME};
	
	$stash->{THIS}->{FILE}->{SOURCE_PATH} = $source_file;
	$stash->{THIS}->{FILE}->{DESTINATION_PATH} = $destination_file;
	
	if ( uc ( $stash->{THIS}->{FILTER}->{NAME} ) eq 'HTML' ) {
		require Trimurti::Vishnu::FileGroup::File::HTML;
		Trimurti::Vishnu::FileGroup::File::HTML::vishnu( $stash );
	} elsif ( uc ( $stash->{THIS}->{FILTER}->{NAME} ) eq 'STATIC' ) {
		require Trimurti::Vishnu::FileGroup::File::Static;
		Trimurti::Vishnu::FileGroup::File::Static::vishnu( $stash );
	}
	
	undef $stash->{THIS}->{FILE};
}

1;
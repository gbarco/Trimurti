package Trimurti::Vishnu::FileGroup::File::Static;

# ============================================================================
# Handles configuration 
# ============================================================================
use strict;
use warnings;
use Carp qw( croak );
use File::Path;
use File::Spec;
use File::Copy;

# ============================================================================
require Exporter;
use vars qw($VERSION @ISA @EXPORT);

@ISA = qw(Exporter);
@EXPORT = qw(process);

# ============================================================================
sub vishnu {
	my ( $stash ) = @_;
	
	File::Path::make_path( File::Spec->catdir ( $stash->{PROJECT}->{BASE}, $stash->{THIS}->{FILE_GROUP}->{DESTINATION} ) );
	
	File::Copy::copy(
		File::Spec->catfile( $stash->{PROJECT}->{BASE}, $stash->{THIS}->{FILE}->{SOURCE_PATH} ),
		File::Spec->catfile( $stash->{THIS}->{FILE_GROUP}->{DESTINATION}, $stash->{THIS}->{FILE}->{DESTINATION_PATH} ),
	) || croak( 'Could not send static file ' . $stash->{THIS}->{FILE}->{SOURCE_PATH} . ' to ' . $stash->{THIS}->{FILE_GROUP}->{DESTINATION} . ' because ' . $! );
}

1;
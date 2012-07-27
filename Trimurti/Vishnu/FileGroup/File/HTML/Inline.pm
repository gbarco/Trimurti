package Trimurti::Vishnu::FileGroup::File::HTML::Inline;

use lib '../../../../../';
# ============================================================================
# Handles configuration 
# ============================================================================
use strict;
use warnings;
use Carp qw( croak );
use HTML::TokeParser;

# ============================================================================
require Exporter;
use vars qw($VERSION @ISA @EXPORT);

@ISA = qw(Exporter);
@EXPORT = qw(process);

# ============================================================================
sub vishnu {
	my ( $stash ) = @_;
	my $text;
	
	foreach my $file ( @{$stash->{THIS}->{MODULE}->{DATA}} ) {
		if ( $file =~ /file\s*=\s*["'](\S+)["']/ ) {
			open( INLINE, $1) || croak('Could not open ' . $1);
			binmode( INLINE );
			my ( $data );
			while ( read (INLINE, $data, 4096) != 0) {
				$text .= $data;
			}
			close( INLINE );
		} else {
			croak('Unknown command');
		}
	}
	
	return $text;
}

1;
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
sub vishnu {
	my ( $stash ) = @_;
	
	foreach my $file ( @{$stash->{THIS}->{FILE_GROUP}->{FILES}}) {
		#get filter and file in the form HTML:test.html
		$file =~ /^(\w+):(.*)$/;
		
		$stash->{THIS}->{FILTER}->{NAME} = $1;
		$stash->{THIS}->{FILE}->{NAME} = $2;
		Trimurti::Vishnu::FileGroup::File::vishnu( $stash );
		undef $stash->{THIS}->{FILTER}->{NAME};
		undef $stash->{THIS}->{FILE}->{NAME};
	}
}

1;
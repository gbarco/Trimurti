package Trimurti::Vishnu::FileGroup;

use lib '../../';
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
	
	crock('No file list in file group ' . $stash->{THIS}->{FILE_GROUP}->{NAME}) unless defined $stash->{THIS}->{FILE_GROUP}->{FILES};
	
	foreach my $file ( @{$stash->{THIS}->{FILE_GROUP}->{FILES}}) {
		#get filter and file in the form HTML:test.html
		$file =~ /^(\w+):(.*)$/;
		
		$stash->{THIS}->{FILTER} = $1;
		$stash->{THIS}->{FILE} = $2;
		Trimurti::Vishnu::FileGroup::File::vishnu( $stash );
		undef $stash->{THIS}->{FILTER} = $1;
		undef $stash->{THIS}->{FILE} = $2;
	}
}

1;
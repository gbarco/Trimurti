package Trimurti::Vishnu::FileGroup::File::HTML;

# ============================================================================
# Handles configuration 
# ============================================================================
use strict;
use warnings;
use Carp qw( croak );
use utf8;

use Template;
use Template::Provider;
use Template::Parser;

use Trimurti::Vishnu::CrStripper;

# ============================================================================
require Exporter;
use vars qw($VERSION @ISA @EXPORT);

@ISA = qw(Exporter);
@EXPORT = qw(process);

# ============================================================================
sub vishnu {
	my ( $stash ) = @_;
	
	my $tt = Template->new({
			ENCODING => 'utf8', #force utf8 encoding for templates
			PRE_CHOMP => 3,
			POST_CHOMP => 3,
			START_TAG => quotemeta('<!-- VISHNU '),
			END_TAG   => quotemeta('-->'),
			LOAD_TEMPLATES => [ Trimurti::Vishnu::CrStripper->new( { INCLUDE_PATH => $stash->{PROJECT}->{BASE} } ) ],
			PLUGIN_BASE => [
											'Trimurti::Vishnu::FileGroup::File::HTML::Filter',
											'Trimurti::Vishnu::FileGroup::File::HTML::Plugin',
										 ],
			PREFIX_MAP => {
        file    => '0',     # file:foo.html
        #http    => '1',     # http:foo.html
        default => '0',     # foo.html => file:foo.html
			},
			OUTPUT => $stash->{THIS}->{FILE}->{DESTINATION_PATH},
			OUTPUT_PATH => $stash->{THIS}->{FILE_GROUP}->{DESTINATION},
	});
	
	#fix CRLF problems
	open my $out_fh, '>:raw', $stash->{THIS}->{FILE_GROUP}->{DESTINATION} . $stash->{THIS}->{FILE}->{DESTINATION_PATH}    or die $stash->{THIS}->{FILE}->{DESTINATION_PATH} . ": $!\n";
	
	$tt->process(
		$stash->{THIS}->{FILE}->{SOURCE_PATH},
		{VISHNU=> $stash},
		$out_fh,
	) || croak( $tt->error() . ' processing ' . $stash->{THIS}->{FILE}->{SOURCE_PATH} );
}

1;
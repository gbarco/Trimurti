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
			TAG_STYLE => 'html',
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
	
	$tt->process(
		$stash->{THIS}->{FILE}->{SOURCE_PATH},
		{VISHNU=> $stash},
	) || croak( $tt->error() . ' processing ' . $stash->{THIS}->{FILE}->{SOURCE_PATH} );
}

1;
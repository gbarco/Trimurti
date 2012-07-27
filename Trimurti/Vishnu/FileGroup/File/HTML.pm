package Trimurti::Vishnu::FileGroup::File::HTML;

use lib '../../../../';
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
	
	my $html_tokenizer = HTML::TokeParser->new( $stash->{THIS}->{SOURCE_FILE_FH} ) || croak('Could not open HTML file ' . $stash->{THIS}->{FILE} );

	while ( my $token = $html_tokenizer->get_token() ) {
	# @$token
	#	["S",  $tag, $attr, $attrseq, $text]
	#	["E",  $tag, $text]
	#	["T",  $text, $is_data]
	#	["C",  $text]
	#	["D",  $text]
	# ["PI", $token0, $text]
		if ( $token->[0] eq 'C' ) {
			#comments might be VISHNU tags
			my $text = $token->[1];
			
			if ( $text =~ /<!--\s*VISHNU\s*TAG=["'](\S+)?["']\s*((?:\S+\s*=\S+\s*)+)?-->/ ) {
				my ( $tag, $data) = ($1, $2);
				my ( @tag_data ) = split( /\s+/,$data) if defined $data;
				#kill extra spaces before and after each key
				@tag_data = map s/^\s+(\S+)\s+=(.*)$/$1=$2/g,@tag_data;
				
				print "Got VISHNU TAG in HTML FILE " . $tag . ">" . join("|", @tag_data);
			} else {
				#copy non VISHNU TAGS verbatim
				$stash->{THIS}->{DESTINATION_FILE_FH}->print( $text );
			}
		} else {
			#pass text verbatim
			my $text;
			if ( $token->[0] eq 'S') {
				$text = $token->[4];
			} elsif ( $token->[0] eq 'E') {
				$text = $token->[1];
			} elsif ( $token->[0] eq 'T') {
				$text = $token->[1];
			} elsif ( $token->[0] eq 'D') {
				$text = $token->[1];
			} elsif ( $token->[0] eq 'PI') {
				$text = $token->[2];
			}
			$stash->{THIS}->{DESTINATION_FILE_FH}->print( $text );
		}
	}	
}

1;
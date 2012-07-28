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
use Trimurti::Vishnu::FileGroup::File::HTML::Inline;

# ============================================================================
require Exporter;
use vars qw($VERSION @ISA @EXPORT);

@ISA = qw(Exporter);
@EXPORT = qw(process);

# ============================================================================
sub vishnu {
	my ( $stash ) = @_;
	
	my $html_tokenizer = HTML::TokeParser->new( $stash->{THIS}->{FILE}->{SOURCE_FILE_FH} ) || croak('Could not open HTML file ' . $stash->{THIS}->{FILE} );

	while ( my $token = $html_tokenizer->get_token() ) {
		if ( $token->[0] eq 'C' ) {
			#comments might be VISHNUsomething
			my $text = $token->[1];
			
			if ( $text =~ /<!--\s*VISHNU\s*(.*?)\s*-->/ ) {
				#this is VISHNUish
				my $vishnu_text = $1;
				
				#TAG = "NoWarnings" data=1 data=2
				#PREPROCESS="Download" url="http://www.time.gov/"
				if ( $vishnu_text =~ /(\w+)\s*=\s*["'](\S+)?["']\s*(.*)/ ) {
					my ( $command, $module, @data ) = ( $1, $2, split( /\s+/,$3 ) );
					
					$stash->{THIS}->{MODULE}->{NAME} = $module;
					$stash->{THIS}->{MODULE}->{DATA} = \@data;
					
					if ( $command eq 'PREPROCESS' ) {
					} elsif ( $command eq 'TAG' ) {
					} elsif ( $command eq 'INCLUDE' ) {
						$text = _include( $stash );
					} elsif ( $command eq 'POSTPROCESS' ) {
					}
					
					$stash->{THIS}->{FILE}->{DESTINATION_FILE_FH}->print( $text ) if defined $text;
				}
			} else {
				#copy non VISHNU TAGS verbatim
				my $text = _text_verbatim( $token );
				
				$stash->{THIS}->{FILE}->{DESTINATION_FILE_FH}->print( $text ) if ( defined $text );
			}
		} else {
			my $text = _text_verbatim( $token );
			
			$stash->{THIS}->{FILE}->{DESTINATION_FILE_FH}->print( $text ) if ( defined $text );
		}
	}	
}
	
sub _include {
	my $stash = shift;
	my $text;
	
	if ( $stash->{THIS}->{MODULE}->{NAME} eq 'Inline' ) {
		$text = Trimurti::Vishnu::FileGroup::File::HTML::Inline::vishnu( $stash );
	}
	
	return $text;	
}

sub _text_verbatim {
	my $token = shift;
	my $text;
	
	#pass text verbatim
	if ( $token->[0] eq 'S') {
		$text = $token->[4];
	} elsif ( $token->[0] eq 'E') {
		$text = $token->[2];
	} elsif ( $token->[0] eq 'T') {
		$text = $token->[1];
	} elsif ( $token->[0] eq 'D') {
		$text = $token->[1];
	} elsif ( $token->[0] eq 'PI') {
		$text = $token->[2];
	}
	
	return $text;
	# @$token
	#	["S",  $tag, $attr, $attrseq, $text]
	#	["E",  $tag, $text]
	#	["T",  $text, $is_data]
	#	["C",  $text]
	#	["D",  $text]
	# ["PI", $token0, $text]
}

1;
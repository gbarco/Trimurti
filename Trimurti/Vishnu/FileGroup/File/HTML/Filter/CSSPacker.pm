package Trimurti::Vishnu::FileGroup::File::HTML::Filter::CSSPacker;

use Template::Plugin::Filter;
use base qw( Template::Plugin::Filter );
use Carp qw( croak );
use CSS::Compressor;

sub init {
    my $self = shift;
    $self->{ _DYNAMIC } = 1;
    return $self;
}

sub filter {
		# [% FILTER $blat 'foo' 'bar' tag = 'script' %]
    my ($self, $text, $args, $conf) = @_;

    # $args = [ 'foo', 'bar' ]
    # $conf = { tag => 'script' }
		
		$text = CSS::Compressor::css_compress ( $text );
		
    return $text;
}

1;
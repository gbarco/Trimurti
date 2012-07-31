package Trimurti::Vishnu::FileGroup::File::HTML::Filter::EncloseTag;

use Template::Plugin::Filter;
use base qw( Template::Plugin::Filter );
use Carp qw( croak );
use Data::Dumper;

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
		
		croak('Trimurti::Vishnu::FileGroup::File::HTML::Filter::EncloseTag no tag provided') unless defined $conf->{'tag'};
		
		$text = "<" . uc( $conf->{'tag'} ) . ">\n" . $text . "\n</" . uc( $conf->{'tag'} ) . ">\n";

    return $text;
}

1;
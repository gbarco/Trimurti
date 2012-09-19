package Trimurti::Vishnu::FileGroup::File::HTML::Filter::Sass;

use Template::Plugin::Filter;
use base qw( Template::Plugin::Filter );
use Carp qw( croak );
use Text::Sass;

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
		
		my $interpreter = Text::Sass->new();
		
    $text = $interpreter->scss2css( $text );

    return $text;
}

1;
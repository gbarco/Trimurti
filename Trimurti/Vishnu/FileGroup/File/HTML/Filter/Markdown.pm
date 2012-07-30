package Trimurti::Vishnu::FileGroup::File::HTML::Filter::Markdown;

use Template::Plugin::Filter;
use base qw( Template::Plugin::Filter );

use Text::MultiMarkdown;

sub init {
    my $self = shift;
    $self->{ _DYNAMIC } = 1;
    return $self;
}

sub filter {
		# [% FILTER $blat 'foo' 'bar' baz = 'blam' %]
    my ($self, $text, $args, $conf) = @_;

    # $args = [ 'foo', 'bar' ]
    # $conf = { baz => 'blam' }
		
		$markdown = Text::MultiMarkdown->new( );
		
		$text = $markdown->markdown( $text );

    return $text;
}

1;
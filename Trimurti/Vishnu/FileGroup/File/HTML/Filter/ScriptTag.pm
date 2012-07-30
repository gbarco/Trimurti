package Trimurti::Vishnu::FileGroup::File::HTML::Filter::ScriptTag;

use Template::Plugin::Filter;
use base qw( Template::Plugin::Filter );

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
		
		$text = "<SCRIPT>\n" . $text . "\n</SCRIPT>\n";

    return $text;
}

1;
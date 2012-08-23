package Trimurti::Vishnu::FileGroup::File::HTML::Filter::NoComments;

use Template::Plugin::Filter;
use base qw( Template::Plugin::Filter );

sub init {
    my $self = shift;
    $self->{ _DYNAMIC } = 1;
    return $self;
}

sub filter {
		# [% FILTER $nocomments %]
    my ($self, $text, $args, $conf) = @_;

    # $args = [ 'foo', 'bar' ]
    # $conf = { baz => 'blam' }
		
		$text =~ s/\<!--[ \r\n\t].*[ \r\n\t]*--\>//g;
	
    return $text;
}

1;
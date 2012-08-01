package Trimurti::Vishnu::FileGroup::File::HTML::Filter::JSPacker;

use Template::Plugin::Filter;
use base qw( Template::Plugin::Filter );
use Carp qw( croak );
use JavaScript::Packer;

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
		
		my $packer = JavaScript::Packer->init();
		
		$conf->{compress} = 'best' unless defined $conf->{compress};

    $packer->minify( \$text , $conf );

    return $text;

#
#compress
#
#    Defines compression level. Possible values are 'clean', 'shrink', 'obfuscate' and 'best'.
#	Default value is 'clean'. 'best' uses 'shrink' or 'obfuscate' depending on which result is shorter.
# This is recommended because especially when compressing short scripts the result will exceed the input if compression level is 'obfuscate'.
#
#copyright
#
#    You can add a copyright notice at the top of the script.
#
#remove_copyright
#
#    If there is a copyright notice in a comment it will only be removed if this option is set to a true value. Otherwise the first comment that contains the word "copyright" will be added at the top of the packed script. A copyright comment will be overwritten by a copyright notice defined with the copyright option.
#
#no_compress_comment
#
#    If not set to a true value it is allowed to set a JavaScript comment that prevents the input being packed or defines a compression level.
#
#        /* JavaScript::Packer _no_compress_ */
#        /* JavaScript::Packer shrink */
#
}

1;
package Trimurti::Vishnu::FileGroup::File::HTML::Filter::CSSPacker;

use Template::Plugin::Filter;
use base qw( Template::Plugin::Filter );
use Carp qw( croak );
use CSS::Packer;

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
		
		my $packer = CSS::Packer->init();
		
		$conf->{compress} = 'minifiy' unless defined $conf->{compress};

    $packer->minify( \$text , $conf );

    return $text;

#		$conf should be:
#		compress
#
#    Defines compression level. Possible values are 'minify' and 'pretty'. Default value is 'pretty'.
#
#    'pretty' converts
#
#        a {
#        color:          black
#        ;}   div
#
#        { width:100px;
#        }
#
#    to
#
#        a{
#        color:black;
#        }
#        div{
#        width:100px;
#        }
#
#    'minify' converts the same rules to
#
#        a{color:black;}div{width:100px;}
#
#copyright
#
#    You can add a copyright notice at the top of the script.
#remove_copyright
#
#    If there is a copyright notice in a comment it will only be removed if this option is set to a true value. Otherwise the first comment that contains the word "copyright" will be added at the top of the packed script. A copyright comment will be overwritten by a copyright notice defined with the copyright option.
#no_compress_comment
#
#    If not set to a true value it is allowed to set a CSS comment that prevents the input being packed or defines a compression level.
#
#        /* CSS::Packer _no_compress_ */
#        /* CSS::Packer pretty */
#

}

1;
use strict;
use Template;
use Carp qw( croak );

my $tt = Template->new({
	ENCODING => 'utf8', #force utf8 encoding for templates
	TAG_STYLE =>'html',
	PREFIX_MAP => {
		file    => '0',     # file:foo.html
		#http    => '1',     # http:foo.html
		default => '0',     # foo.html => file:foo.html
	},
});

$tt->process('tttest.tt',{foo=>1},) || croak( $tt->error() );
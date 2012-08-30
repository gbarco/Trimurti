use strict;
use LWP::UserAgent;
use HTML::LinkExtor;
use URI::URL;

my $url = "http://www.perl.org/";  # for instance
my $ua = LWP::UserAgent->new;

# Set up a callback that collect image links
my @imgs = ();
sub callback {
	 my($tag, %attr) = @_;
	 return if $tag eq 'a';
	 #return if $tag ne 'img';  # we only look closer at <img ...>
	 print $tag . "->" . join(",", values %attr ) . "\n";
	 push(@imgs, values %attr);
}

# Make the parser.  Unfortunately, we don't know the base yet
# (it might be different from $url)
my $p = HTML::LinkExtor->new(\&callback);

# Request document and parse it as it arrives
my $res = $ua->request(HTTP::Request->new(GET => $url),
										sub {$p->parse($_[0])});

# Expand all image URLs to absolute ones
my $base = $res->base;
@imgs = map { $_ = url($_, $base)->abs; } @imgs;

# Print them out
#print join("\n", @imgs), "\n";
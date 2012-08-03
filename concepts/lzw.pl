use strict;
use Compress::LZW;

binmode STDIN;
binmode STDOUT;

my $data;

while (<>) {
	$data .= $_;
}

print compress($data);
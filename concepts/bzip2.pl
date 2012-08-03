use strict;
use Compress::Bzip2;

binmode STDIN;
binmode STDOUT;

my $data;

while (<>) {
	$data .= $_;
}

my $mojo = Compress::Bzip2::memGzip($data);

print STDOUT $mojo;
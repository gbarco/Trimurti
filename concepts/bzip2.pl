use strict;
use Compress::Bzip2;

binmode STDIN;
binmode STDOUT;

my $read_length = 8192;

my $data;

*BZOUT = *STDOUT;
my $bz = Compress::Bzip2->new();
$bz->bzopen( \*BZOUT,'w');

$bz->bzwrite( $data ) while ( read ( STDIN, $data, $read_length ) );

$bz->bzflush();
$bz->bzclose();






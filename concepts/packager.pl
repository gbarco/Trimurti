use strict;
use utf8;
use JSON;
use File::Glob;
use Compress::Bzip2;

my $read_length = 8192;

my $data;

my $package = 'scripts.pack.bz2';
my @files = File::Glob::bsd_glob('package/*.js');
my @filedata;

my $offset = 0;
for my $file ( @files ) {
	my $size = -s $file;
	push @filedata, {size=>$size,offset=>$offset,filename=>$file};
	$offset +=$size;
}

my $json = JSON::to_json( \@filedata );

my $bz = Compress::Bzip2->new();
$bz->bzopen( $package,'w');

$bz->bzwrite( $json . "\n" );

for my $file ( @files ) {
	my $data;
	my $size = -s $file;

	open ( INPUT, $file );
	binmode( INPUT );
	
	$bz->bzwrite( $data ) while( INPUT->read( $data, 8192 ));
	
	INPUT->close();
}

$bz->bzflush();
$bz->bzclose();


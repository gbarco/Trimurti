use strict;
use Net::SSH2;
use Fcntl;

my $ssh = Net::SSH2->new();
$ssh->connect('10.152.18.4',222, Timeout=>30);
print $ssh->auth_list ('gbarco');
$ssh->auth_publickey ( 'gbarco', 'K:\Documents\keys\weak.pub.openssh', 'K:\Documents\keys\weak.priv.openssh' );

my $sftp = $ssh->sftp();

my $buffer;

my $file = 'Articulo%201.html';
		
my $remote_file = $sftp->open($file, O_CREAT | O_WRONLY) || die ( 'Trimurti::Shiva::FileGroup::SFTP could not create remote file ' . $file . ' with error ' . join(" ", $sftp->error()) );

open ( SOURCE, $0 );
binmode SOURCE;

my $bytes_read;
do {
	$bytes_read = read( SOURCE, $buffer, 8192 );
} while ( $bytes_read > 0 && $bytes_read == $remote_file->write( $buffer ) );

close ( SOURCE );

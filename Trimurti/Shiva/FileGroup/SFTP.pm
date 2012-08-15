package Trimurti::Shiva::FileGroup::SFTP;

# ============================================================================
# Transfers files using SFTP with provided credentials
# ============================================================================
use strict;
use warnings;
use Carp qw( croak );
use File::Spec;
use Fcntl;
use Net::SSH2;

# ============================================================================
require Exporter;
use vars qw($VERSION @ISA @EXPORT);

@ISA = qw(Exporter);
@EXPORT = qw(shiva);

# ============================================================================
sub shiva {
	my ( $stash ) = @_;
	
	my $ssh = Net::SSH2->new();
	
	$ssh->connect(
		$stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{HOST},
		$stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{PORT} || 22,
		Timeout=> $stash->{THIS}->{FILE_GROUP}->{TIMEOUT} || 30
	); #like connect ( host [, port [, Timeout => secs ]] )
	
	my ( %auth_args );
	
	$auth_args{rank} = [ 'publickey', 'password' ]; #only non-interactive
	$auth_args{username} = $stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{CREDENTIALS}->{USERNAME} if ( defined $stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{CREDENTIALS}->{USERNAME});
	$auth_args{password} = $stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{CREDENTIALS}->{PASSWORD} if ( defined $stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{CREDENTIALS}->{PASSWORD});
	$auth_args{publickey} = $stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{CREDENTIALS}->{PUBLICKEY} if ( defined $stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{CREDENTIALS}->{PUBLICKEY});
	$auth_args{privatekey} = $stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{CREDENTIALS}->{PRIVATEKEY} if ( defined $stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{CREDENTIALS}->{PRIVATEKEY});
	
	$ssh->auth( %auth_args );
	
	croak('Trimurti::Shiva::FileGroup::SFTP could not connect to ' . $stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{HOST})
		unless $ssh->auth_ok();
	
	my $sftp = $ssh->sftp();
	
	my @path;
	
	#create dirs with no errors if they do not exist... once... although one might asynchronosly remove them while we upload
	#first element should eq '' since path is /a/b ; last element might be eq '' since path might be /a/b/
	#path should start with / which gets split by /[\\\/]/, so add it
	map {
		push (@path, $_) if ($_ ne '');
		$sftp->mkdir( File::Spec::Unix->rootdir . File::Spec::Unix->catfile( @path ) ); #/$path[0]/$path[1]/(...)/$path[n]
	} split( /[\\\/]/, $stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{PATH});
	
	foreach my $file ( @{$stash->{THIS}->{FILE_GROUP}->{FILES}} ) {
		my $buffer;
		
		my $remote_filename = File::Spec::Unix->catfile( $stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{PATH}, File::Basename::basename($file) );
		my $remote_file_fh = $sftp->open( $remote_filename, O_CREAT | O_WRONLY) || croak ( 'Trimurti::Shiva::FileGroup::SFTP could not create remote file ' . $file . ' with error ' . $sftp->error() );
		
		open ( SOURCE, $file );
		binmode SOURCE;
		
		my $bytes_read;
		
		do {
			$bytes_read = read( SOURCE, $buffer, 8192 );
			if ( $bytes_read != $remote_file_fh->write( $buffer ) )  {
				croak ( 'Trimurti::Shiva::FileGroup::SFTP error writing to ' . $file);
			}
		} while ( $bytes_read > 0 );
		
		close ( SOURCE );
	}
	$ssh->disconnect();
}
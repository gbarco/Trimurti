package Trimurti::Shiva::FileGroup::SFTP;

# ============================================================================
# Transfers files using SFTP with provided credentials
# ============================================================================
use strict;
use warnings;
use Carp qw( croak );
use File::Spec;
use Net::SFTP::Foreign;

# ============================================================================
require Exporter;
use vars qw($VERSION @ISA @EXPORT);

@ISA = qw(Exporter);
@EXPORT = qw(shiva);

# ============================================================================
sub shiva {
	my ( $stash ) = @_;
	
	my %args;
	
	#username/password credentials
	if ( defined $stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{CREDENTIALS}->{USERNAME} ) {
		%args = (
			user=>$stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{CREDENTIALS}->{USERNAME},
			password=>$stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{CREDENTIALS}->{PASSWORD},
		);
	} elsif ( defined $stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{CREDENTIALS}->{KEYFILE} ) {
		%args = (
			ssh_args => { identity_files => [ $stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{CREDENTIALS}->{KEYFILE} ], protocol=>'2,1',} 
		);
	} else {
		croak('Trimurti::Shiva::FileGroup::SFTP unknown credentials in group ' . $stash->{THIS}->{FILE_GROUP}->{NAME} );
	}
	
	my $host = join(':', $stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{HOST}, $stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{PORT} );
	
	my $sftp = Net::SFTP::Foreign->new( $host, %args ) ||
		croak('Trimurti::Shiva::FileGroup::SFTP could not connect to ' . $host);
	
	foreach my $file ( @{$stash->{THIS}->{FILE_GROUP}->{FILES}} ) {
		my $remote_path = File::Spec::catfile( $stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{PATH}, $file );
		$sftp->put( $file, $remote_path ) || croak ( 'Trimurti::Shiva::FileGroup::SFTP could not put file ' . $file . ' to ' . $host );
	}
}
package Trimurti::Shiva::FileGroup::SFTP;

# ============================================================================
# Transfers files using SFTP with provided credentials
# ============================================================================
use strict;
use warnings;
use Carp qw( croak );
use File::Spec;

# ============================================================================
require Exporter;
use vars qw($VERSION @ISA @EXPORT);

@ISA = qw(Exporter);
@EXPORT = qw(shiva);

# ============================================================================
sub shiva {
	my $stash = ( @_ );
	
	my %args;
	
	#username/password credentials
	if ( defined $stash->{THIS}->{FILEGROUP}->{DESTINATION}->{CREDENTIALS}->{USERNAME} ) {
		%args = (
			user=>$stash->{THIS}->{FILEGROUP}->{DESTINATION}->{CREDENTIALS}->{USERNAME},
			password=>$stash->{THIS}->{FILEGROUP}->{DESTINATION}->{CREDENTIALS}->{PASSWORD},
		);
	} elsif ( defined $stash->{THIS}->{FILEGROUP}->{DESTINATION}->{CREDENTIALS}->{KEYFILE} ) {
		%args = (
			ssh_args => { identity_files => [ $stash->{THIS}->{FILEGROUP}->{DESTINATION}->{CREDENTIALS}->{KEYFILE} ], protocol=>'2,1',} 
		);
	} else {
		croak('Trimurti::Shiva::FileGroup::SFTP unknown credentials in group ' . $stash->{THIS}->{FILEGROUP}->{NAME} );
	}
	
	my $host = join(':', $stash->{THIS}->{FILEGROUP}->{DESTINATION}->{HOST}, $stash->{THIS}->{FILEGROUP}->{DESTINATION}->{PORT} );
	
	my $sftp = Net::SFTP( $host, %args ) ||
		croak('Trimurti::Shiva::FileGroup::SFTP could not connect to ' . $host);
	
	foreach my $file ( @{$stash->{THIS}->{FILEGROUP}->{FILES}} ) {
		my $remote_path = File::Spec::catfile( $stash->{THIS}->{FILEGROUP}->{DESTINATION}->{PATH}, $file );
		$sftp->put( $file, $remote_path ) || croak ( 'Trimurti::Shiva::FileGroup::SFTP could not put file ' . $file . ' to ' . $host );
	}
}
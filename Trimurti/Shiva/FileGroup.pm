package Trimurti::Shiva::FileGroup;

use lib '../../';
# ============================================================================
# Handles configuration 
# ============================================================================
use strict;
use warnings;
use Carp qw( croak );
use File::Glob;

# ============================================================================
use Trimurti::Shiva::Credentials;
use Trimurti::Shiva::FileGroup::SFTP;

# ============================================================================
require Exporter;
use vars qw($VERSION @ISA @EXPORT);

@ISA = qw(Exporter);
@EXPORT = qw(shiva);

# ============================================================================
sub shiva {
	my ( $stash ) = @_;
	
	$stash->{THIS}->{FILE_GROUP}->{DESTINATION} =~ m#(?:(s3|file|scp|sftp|ssh|rsync|telnet|http|https|ftp|ftps)://)+((?:[a-zA-Z0-9\._-]+\.[a-zA-Z]{2,6})|(?:[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(?::([0-9]+))?(/[a-zA-Z0-9\&amp;%_\./-~-]*)?#;
	$stash->{THIS}->{FILE_GROUP}->{DESTINATION} = {
		URI=> $stash->{THIS}->{FILE_GROUP}->{DESTINATION}, #safeguard destination
		SERVER=> lc $2 . ':' . $3, #10.0.0.1:22
		PROTOCOL=> lc $1,
		HOST=> lc $2,
		PORT=> $3,
		PATH=> $4, #this is case sensitive
	};
		
	my $protocol_dispachers = {
		s3=>\&Trimurti::Shiva::FileGroup::Unimplemented::shiva,
		file=>\&Trimurti::Shiva::FileGroup::Unimplemented::shiva,
		scp=>\&Trimurti::Shiva::FileGroup::Unimplemented::shiva,
		sftp=>\&Trimurti::Shiva::FileGroup::SFTP::shiva,
		ssh=>\&Trimurti::Shiva::FileGroup::Unimplemented::shiva,
		rsync=>\&Trimurti::Shiva::FileGroup::Unimplemented::shiva,
		telnet=>\&Trimurti::Shiva::FileGroup::Unimplemented::shiva,
		http=>\&Trimurti::Shiva::FileGroup::Unimplemented::shiva,
		ftp=>\&Trimurti::Shiva::FileGroup::Unimplemented::shiva,
		ftps=>\&Trimurti::Shiva::FileGroup::Unimplemented::shiva,
		https=>\&Trimurti::Shiva::FileGroup::Unimplemented::shiva,
		_unimplemented=>\&Trimurti::Shiva::FileGroup::Unimplemented::shiva,
	};
		
	my $credentials = Trimurti::Shiva::Credentials::read_credentials( $stash->{THIS}->{FILE_GROUP}->{CREDENTIALS} );
		
	#croak if we cannot find credentials for this server in the {FILE_GROUP}->{CREDENTIALS}
	unless ( defined $credentials->{ $stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{SERVER} } ) {
		croak('Trimurti::Shiva::FileGroup no credentials for ' .  $stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{SERVER} . ' in filegroup ' .  $stash->{THIS}->{FILE_GROUP}->{NAME} );
	} else {
		$stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{CREDENTIALS} = $credentials->{ $stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{SERVER} };
	}
	
	#should take care of all @{$stash->{THIS}->{FILE_GROUP}->{FILES}}
	$protocol_dispachers->{$stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{PROTOCOL}}( $stash );
	
	$stash->{THIS}->{FILE_GROUP}->{DESTINATION} = $stash->{THIS}->{FILE_GROUP}->{DESTINATION}->{URI};
}

1;